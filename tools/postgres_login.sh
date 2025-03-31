#!/bin/bash
set -x

docker compose exec -it postgres psql -U postgres -d cexplorer
