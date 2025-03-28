#!/bin/bash

export CARDANO_NODE_CONFIG_PATH=../../../config/network/preprod/cardano-node/config.json
export HASURA_URI="http://localhost:8090"

cd packages/server/dist/

node index.js