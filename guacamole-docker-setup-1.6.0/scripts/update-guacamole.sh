#!/bin/bash
set -euo pipefail
source .env

echo "Stopping stack..."
docker compose down

echo "Pulling latest images..."
docker compose pull

echo "Starting stack..."
docker compose up -d

echo "Done. All services are updated."