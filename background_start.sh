#!/bin/bash

export HASURA_CLI_PATH=/usr/local/bin/hasura
export HASURA_CLI_EXT_PATH=/usr/local/bin/hasura-cli_ext
export HASURA_URI="http://localhost:8090"
export METADATA_SERVER_URI="https://tokens.cardano.org"
export POSTGRES_PORT=5432
export POSTGRES_DB_FILE=./placeholder-secrets/postgres_db
export POSTGRES_PASSWORD_FILE=./placeholder-secrets/postgres_password
export POSTGRES_USER_FILE=./placeholder-secrets/postgres_user
export POSTGRES_HOST=localhost
export OGMIOS_HOST=localhost
export OGMIOS_PORT=1337

export CHAIN_FOLLOWER_START_SLOT=0
export CHAIN_FOLLOWER_START_ID=""

node packages/api-cardano-db-hasura/dist/background.js