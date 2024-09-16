#!/bin/bash

cd ..

export COMPOSE_FILES="$(find . -mindepth 2 -maxdepth 2 | grep "/compose.yaml")"

for COMPOSE_FILE in $COMPOSE_FILES
do
    echo $COMPOSE_FILE
    docker compose -f $COMPOSE_FILE up -d --remove-orphans #--build
done
