#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(dirname "$0")"

# Define the path to the default environment file relative to the script's location
DEFAULT_ENV="$SCRIPT_DIR/../default.env"

# Check if the default.env file exists in the parent directory
if [ ! -f "$DEFAULT_ENV" ]; then
    echo "Error: default.env file not found in the parent directory."
    exit 1
fi

# Switch to the parent directory
cd "$SCRIPT_DIR/.."

# Loop through each folder in the root directory, except the .scripts folder
for dir in */ ; do
    # Skip the .scripts folder
    if [ "$dir" == ".scripts/" ]; then
        continue
    fi

    # Create a symlink to the default.env file in each folder
    if [ -d "$dir" ]; then
        ln -sf "../default.env" "$dir/default.env"
        echo "Created symlink for default.env in $dir"
    fi
done

