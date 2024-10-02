#!/bin/bash

# Stop and remove all Docker containers
echo "Stopping and removing all Docker containers..."
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

# Run your two scripts
echo "Creating symlinks..."
./create_env_symlinks.sh

echo "Cleaning docker assets..."
./manage-services.sh --clean


echo "Start all containers in run_list..."

.scripts/manage-services.sh --pull --launch --clean

echo "Done!"
