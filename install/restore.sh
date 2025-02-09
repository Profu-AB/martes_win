#!/bin/bash


echo "Restoring backup in : ../backup"

echo docker exec martes_mongodb rm -rf /restore_backup
docker exec martes_mongodb rm -rf /restore_backup

echo docker cp  ../backup martes_mongodb:/restore_backup
docker cp  ../backup martes_mongodb:/restore_backup

echo docker exec -i martes_mongodb mongorestore --username admin --password secret --authenticationDatabase admin --drop --dir /restore_backup --nsExclude='admin.*'
docker exec -i martes_mongodb mongorestore --username admin --password secret --authenticationDatabase admin --drop --dir /restore_backup --nsExclude='admin.*'
