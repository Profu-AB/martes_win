#!/bin/bash
echo remove folder /backup
rm -rf backup
mkdir backup
# cp -r $LINUX_PATH/* ./backup/

echo remove folder mongo_backup inside container
docker exec martes_mongodb rm -rf /mongo_backup

echo performs the backup
docker exec -i martes_mongodb mongodump --username admin --password secret --authenticationDatabase admin --out ./mongo_backup

echo copy the files back to windows
docker cp martes_mongodb:./mongo_backup ./martes_data_backup

