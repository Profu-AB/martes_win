
#!/bin/bash

# Check if LICENSE is passed as an argument
if [ -z "$1" ]; then
    echo "Error: LICENSE parameter is missing."
    echo "Usage: ./import_access.sh <LICENSE>"
    exit 1
fi

LICENSE="$1"

# Get the current directory (Linux path)
CURRENT_PATH=$(pwd)

# Print current directory and backup path
echo "Reading access databases from: $CURRENT_PATH/msaccess"

docker exec martes_backend rm -rf /app/msaccess
docker cp ./msaccess martes_backend:/app/msaccess
# Execute the import.sh script located in the /app folder of the container
# docker exec martes_backend sh -c "cd /app && ./import.sh"
docker exec martes_backend sh -c "cd /app && ./import.sh -lk '$LICENSE'"

