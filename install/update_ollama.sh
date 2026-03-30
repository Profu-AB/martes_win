#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.ollama.yaml"

echo "=== Joule AI (Ollama) - Uppdatering ==="
echo ""

if ! docker ps -a --format "{{.Names}}" | grep -q "martes_ollama"; then
    echo "Ollama ar inte installerat. Kor install_ollama.bat forst."
    exit 1
fi

echo "Stoppar Ollama..."
docker compose -f "$COMPOSE_FILE" down

echo ""
echo "Laddar ner senaste Ollama image..."
docker compose -f "$COMPOSE_FILE" pull

echo ""
echo "Startar Ollama..."
docker compose -f "$COMPOSE_FILE" up -d

echo ""
echo "Rensar gamla images..."
docker image prune -f

echo ""
echo "=== Uppdatering klar ==="
