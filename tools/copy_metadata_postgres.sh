#!/bin/bash
# set -x

psql_command='docker compose exec -it postgres psql -U postgres -d cexplorer -t -A -c'

result=`${psql_command} "$(cat tools/cip-26-setup-token-registry.sql)"`
echo ${result} > ./tools/results/copy_info.json


