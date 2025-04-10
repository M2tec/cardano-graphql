#!/bin/bash

docker login docker.io
CONTAINER_ID=`docker ps --filter "name=background" --format "{{.ID}}"`
docker commit ${CONTAINER_ID} cardano-graphql-background:8.3.3
docker tag cardano-graphql-background:8.3.3 m2tec/cardano-graphql-background:8.3.3
docker push m2tec/cardano-graphql-background:8.3.3
