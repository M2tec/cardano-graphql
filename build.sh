#!/bin/bash

docker compose up -d postgres \
                     cardano-node \
                     ogmios \
                     cardano-db-sync \
                     token-metadata-registry \
                     pgadmin \
                     get-hash

docker compose up -d --build \
                     hasura \
                     background \
                     server