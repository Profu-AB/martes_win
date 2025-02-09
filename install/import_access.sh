
#!/bin/bash

# Get the current directory (Linux path)
CURRENT_PATH=$(pwd)

# Print current directory and backup path
echo "Reading access databases from: $CURRENT_PATH/msaccess"

docker exec martes_backend rm -rf /msaccess
docker cp ./msaccess martes_backend:/msaccess
# Execute the import.sh script located in the /app folder of the container
docker exec martes_backend sh -c "cd /app && ./import.sh"