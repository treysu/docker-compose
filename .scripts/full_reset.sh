
#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Stop and remove all Docker containers
echo "Stopping and removing all Docker containers..."
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

# Run your two scripts
echo "Creating symlinks..."
"$SCRIPT_DIR/create_env_symlinks.sh"

echo "Cleaning docker assets..."
"$SCRIPT_DIR/manage-services.sh" --clean

echo "Starting all containers in run_list..."
"$SCRIPT_DIR/manage-services.sh" --pull --launch

echo "Done!"

