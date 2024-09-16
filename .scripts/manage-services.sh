#!/bin/bash

# Function to display the usage information
usage() {
    echo "Usage: $0 [--launch] [--restart] [--pull] [--shutdown] [--clean]"
    echo "    --launch     Launch Docker Compose services"
    echo "    --restart    Restart Docker Compose services"
    echo "    --pull       Pull latest Docker images"
    echo "    --shutdown   Shutdown Docker Compose services"
    echo "    --clean      Prune all unused Docker objects (volumes, networks, images, containers)"
    echo "If run_list or blacklist is present in the root directory, the script will use it to determine which folders to include or exclude."
    exit 1
}

# Check if no arguments are provided
if [ $# -eq 0 ]; then
    usage
fi

# Flags for the operations
LAUNCH=false
RESTART=false
PULL=false
SHUTDOWN=false
CLEAN=false

# Parse the input flags
for arg in "$@"
do
    case $arg in
        --launch)
        LAUNCH=true
        shift
        ;;
        --restart)
        RESTART=true
        shift
        ;;
        --pull)
        PULL=true
        shift
        ;;
        --shutdown)
        SHUTDOWN=true
        shift
        ;;
        --clean)
        CLEAN=true
        shift
        ;;
        --help)
        usage
        ;;
        *)
        usage
        ;;
    esac
done

# Change to the script's parent directory
cd "$(dirname "$0")/.."

# Check for run_list or blacklist file in the root directory
if [ -f "$0/run_list" ]; then
    # If run_list exists, read the allowed folders from it
    ALLOWED_FOLDERS=$(cat run_list)
elif [ -f "$0/run_all_except_list" ]; then
    # If blacklist exists, read the disallowed folders from it
    DISALLOWED_FOLDERS=$(cat blacklist)
fi

# Loop through each folder in the root directory
for dir in */ ; do
    # Strip the trailing slash from the directory name
    folder=${dir%/}
    
    # Check if the directory contains a compose.yaml file
    if [ -f "$folder/compose.yaml" ]; then
        # Determine if this folder should be included or excluded
        if [ -n "$ALLOWED_FOLDERS" ]; then
            # If run_list is defined, only process folders in the run_list
            if ! grep -qx "$folder" run_list; then
                echo "Skipping $folder (not in run_list)"
                continue
            fi
        elif [ -n "$DISALLOWED_FOLDERS" ]; then
            # If blacklist is defined, skip folders in the blacklist
            if grep -qx "$folder" blacklist; then
                echo "Skipping $folder (in blacklist)"
                continue
            fi
        fi
        
        # Perform the requested operations
        if [ "$PULL" = true ]; then
            echo "Pulling latest Docker images for $folder"
            docker compose -f "$folder/compose.yaml" pull
        fi
        if [ "$LAUNCH" = true ]; then
            echo "Launching Docker Compose for $folder"
            docker compose -f "$folder/compose.yaml" up -d
        fi
        if [ "$RESTART" = true ]; then
            echo "Restarting Docker Compose for $folder"
            docker compose -f "$folder/compose.yaml" restart
        fi
        if [ "$SHUTDOWN" = true ]; then
            echo "Shutting down Docker Compose for $folder"
            docker compose -f "$folder/compose.yaml" down
        fi
    fi
done

# Perform the clean operation if requested
if [ "$CLEAN" = true ]; then
    echo "Pruning all unused Docker objects (volumes, networks, images, containers)"
    docker system prune -a --volumes -f
fi

