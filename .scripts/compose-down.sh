#!/bin/bash

cd ..
export COMPOSE_FILES="$(find . -mindepth 2 -maxdepth 2 | grep "/compose.yaml")"

for COMPOSE_FILE in $COMPOSE_FILES
do
    docker compose -f $COMPOSE_FILE down --remove-orphans
done
