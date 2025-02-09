#!/bin/bash

# Get the current directory (Linux path)
CURRENT_PATH=$(pwd)

# Print current directory and backup path
echo "Restoring backup from: $CURRENT_PATH/../backup"

# Remove the existing backup directory in the container
echo "Removing existing /restore_backup in the container"
docker exec martes_mongodb rm -rf /restore_backup

# Copy the backup folder to the container
echo "Copying backup to container"
docker cp $CURRENT_PATH/../backup martes_mongodb:/restore_backup

# Run mongorestore command inside the container
echo "Restoring backup in MongoDB"
docker exec -i martes_mongodb mongorestore --username admin --password secret --authenticationDatabase admin --drop --dir /restore_backup --nsExclude='admin.*'
