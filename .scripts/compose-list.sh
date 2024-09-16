#!/bin/bash

cd ..

export COMPOSE_FILES="$(find . -mindepth 2 -maxdepth 2 | grep "/compose.yaml")"

for COMPOSE_FILE in $COMPOSE_FILES
do
    echo $COMPOSE_FILE
    docker compose -f $COMPOSE_FILE ps --format "table {{.ID}}\t{{.Project}}\t{{.Service}}\t{{.Name}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Size}}"| (read -r; printf "%s\n" "$REPLY"; sort -k 4)
    echo ---
    echo
done
