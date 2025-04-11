import { errors, RunnableModuleState } from '@cardano-graphql/util'
import { dummyLogger, Logger } from 'ts-log'
import PgBoss, { JobWithDoneCallback } from 'pg-boss'
import { DbConfig } from './typeAliases'
import { HasuraBackgroundClient } from './HasuraBackgroundClient'

const ASSET_METADATA_FETCH_INITIAL = 'asset-metadata-fetch-initial'
const ASSET_METADATA_FETCH_UPDATE = 'asset-metadata-fetch-update'

type AssetJobPayload = { assetId: string }
const MODULE_NAME = 'Worker'

export class Worker {
  private queue: PgBoss
  private state: RunnableModuleState

  constructor (
    readonly hasuraClient: HasuraBackgroundClient,
    private logger: Logger = dummyLogger,
    private queueConfig: DbConfig,
  ) {
    this.state = 'initialized'
  }

  public async start () {
    if (this.state !== 'initialized') {
      throw new errors.ModuleIsNotInitialized(MODULE_NAME, 'start')
    }
    this.logger.info({ module: MODULE_NAME }, 'Starting')
    this.queue = new PgBoss({
      application_name: 'cardano-graphql',
      ...this.queueConfig
    })
    const subscriptionHandler: PgBoss.SubscribeHandler<AssetJobPayload, void> = async (data: object) => {
      // The TypeDef doesn't cover the valid batch data, so a user-defined guard is used.
      if ('length' in data) {
        const jobs = data as JobWithDoneCallback<AssetJobPayload, void>[]
        this.logger.debug({ module: MODULE_NAME, qty: jobs.length }, 'Processing jobs')
      }
    }
    await this.queue.start()
    await this.queue.subscribe<AssetJobPayload, void>(ASSET_METADATA_FETCH_INITIAL,
      {
        batchSize: 10000,
        newJobCheckIntervalSeconds: 5
      },
      subscriptionHandler)
    await this.queue.subscribe<AssetJobPayload, void>(ASSET_METADATA_FETCH_UPDATE,
      {
        batchSize: 10000,
        newJobCheckIntervalSeconds: 5
      },
      subscriptionHandler)
    this.logger.info({ module: MODULE_NAME }, 'Started')
  }

  public async shutdown () {
    if (this.state !== 'running') {
      throw new errors.ModuleIsNotInitialized(MODULE_NAME, 'shutdown')
    }
    this.logger.info({ module: MODULE_NAME }, 'Shutting down')
    await Promise.all([
      this.queue.unsubscribe(ASSET_METADATA_FETCH_INITIAL),
      this.queue.unsubscribe(ASSET_METADATA_FETCH_UPDATE)
    ])
    this.state = 'initialized'
    this.logger.info({ module: MODULE_NAME }, 'Shutdown complete')
  }
}
