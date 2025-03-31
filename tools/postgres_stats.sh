#!/bin/bash
# set -x

psql_command='docker compose exec -it postgres psql -U postgres -d cexplorer -t -A -c'

result=`${psql_command} "SHOW config_file;"`

result=`${psql_command} "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"`

result=`${psql_command} "$(cat stats_call_time.sql)"`
echo ${result} > ./results/stats_call_time.json

result=`${psql_command} "$(cat stats_block_read.sql)"`
echo ${result} > ./results/stats_block_read.json
