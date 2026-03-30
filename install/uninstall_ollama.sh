#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.ollama.yaml"

echo "=== Joule AI (Ollama) - Avinstallation ==="
echo ""

echo "Stoppar och tar bort Ollama container..."
docker compose -f "$COMPOSE_FILE" down

echo ""
echo "Tar bort Ollama data volume..."
docker volume rm app_ollama_data 2>/dev/null || true

echo "Tar bort Ollama image..."
docker rmi profu/martes-ollama:latest 2>/dev/null || true

echo ""
echo "=== Avinstallation klar ==="
