#!/usr/bin/env bash
set -euo pipefail

# Args from BAT:
#   $1 = project root (WSL path)
#   $2 = backup destination (WSL path)  e.g. /mnt/c/.../backups/2026-01-25
PROJECT_ROOT="${1:?Missing arg1: project root (WSL path)}"
BACKUP_BASE="${2:?Missing arg2: backup destination (WSL path)}"

# Optional: ensure we run from project root (so relative paths are stable)
cd "$PROJECT_ROOT"

# Create unique folder per run to avoid overwrite
TS="$(date +'%H-%M-%S')"
BACKUP_DIR="${BACKUP_BASE}/${TS}"
mkdir -p "$BACKUP_DIR"

echo "PROJECT_ROOT = $PROJECT_ROOT"
echo "BACKUP_DIR   = $BACKUP_DIR"

# Cleanup inside container (optional)
docker exec martes_mongodb_dev rm -rf /backup /mongo_backup >/dev/null 2>&1 || true

# Create dump inside container (writes to container filesystem)
docker exec -i martes_mongodb_dev mongodump \
  --username admin \
  --password secret \
  --authenticationDatabase admin \
  --out /mongo_backup

# Copy dump from container to host into BACKUP_DIR
docker cp martes_mongodb_dev:/mongo_backup "$BACKUP_DIR/mongo_backup"

echo "Mongo backup klar: $BACKUP_DIR/mongo_backup"
