#!/bin/bash

/usr/local/bin/hasura --cli-ext-path /usr/local/bin/hasura-cli_ext \
                      --skip-update-check \
                      --project /home/maarten/src/m2-graphql/packages/api-cardano-db-hasura/hasura/project \
                      --endpoint http://localhost:8090 migrate \
                      --database-name default apply \
                      --down all