#!/bin/bash

docker compose exec -it cardano-node cardano-cli query tip --socket-path /ipc/node.socket --testnet-magic 1