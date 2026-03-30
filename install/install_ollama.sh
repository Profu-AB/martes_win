#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.ollama.yaml"

echo "=== Joule AI (Ollama) - Installation ==="
echo ""

if ! docker network ls --format "{{.Name}}" | grep -q "install_app_default"; then
    echo "FEL: Martes-natverket finns inte."
    echo "Starta Martes forst (start.bat) innan du installerar Ollama."
    exit 1
fi

echo "Laddar ner Ollama Docker image (~11 GB, detta kan ta en stund)..."
docker compose -f "$COMPOSE_FILE" pull

echo ""
echo "Startar Ollama..."
docker compose -f "$COMPOSE_FILE" up -d

echo ""
echo "=== Installation klar ==="
echo "Ollama kors nu pa port 11434."
echo ""
echo "Starta om Martes backend (kor update.bat) for att aktivera Joule AI."
