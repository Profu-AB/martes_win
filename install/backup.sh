#!/usr/bin/env bash
set -euo pipefail

# Arg1 från BAT: backup destination (WSL path), t.ex. /mnt/c/.../backups/2026-01-25
BACKUP_BASE="${1:?Usage: $0 <backup_destination_wsl_path>}"

# Skapa unik undermapp per körning (samma som dev)
TS="$(date +'%H-%M-%S')"
BACKUP_DIR="${BACKUP_BASE}/${TS}"

echo "Backup destination: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

echo "Remove folder mongo_backup inside container (if exists)"
docker exec martes_mongodb rm -rf /mongo_backup >/dev/null 2>&1 || true

echo "Perform mongodump inside container"
docker exec -i martes_mongodb mongodump \
  --username admin \
  --password secret \
  --authenticationDatabase admin \
  --out /mongo_backup

echo "Copy dump from container to host backup folder"
docker cp martes_mongodb:/mongo_backup "$BACKUP_DIR/mongo_backup"

echo "Done: $BACKUP_DIR/mongo_backup"
