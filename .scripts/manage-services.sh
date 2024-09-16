#!/bin/bash

# Define the path to the default environment file in the parent directory
DEFAULT_ENV="../default.env"

# Check if the default.env file exists in the parent directory
if [ ! -f "$DEFAULT_ENV" ]; then
    echo "Error: $DEFAULT_ENV file not found in the parent directory."
    exit 1
fi

# Change to the script's parent directory
cd "$(dirname "$0")/.."

# Loop through each folder in the root directory, except the .scripts folder
for dir in */ ; do
    # Skip the .scripts folder
    if [ "$dir" == ".scripts/" ]; then
        continue
    fi

    # Create a symlink to the default.env file in each folder
    if [ -d "$dir" ]; then
        ln -sf "$DEFAULT_ENV" "$dir/default.env"
        echo "Created symlink for default.env in $dir"
    fi
done
