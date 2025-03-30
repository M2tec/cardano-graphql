#!/bin/bash

curl --proto '=https' --tlsv1.2 -sSf -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash

HASURA_GRAPHQL_ENABLE_TELEMETRY=false
sudo hasura --skip-update-check update-cli --version v2.17.1
sudo hasura --skip-update-check plugins install cli-ext
sudo cp /root/.hasura/plugins/bin/hasura-cli_ext /usr/local/bin