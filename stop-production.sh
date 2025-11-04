#!/bin/bash

# Postiz Stop Script
# Cleanly stops all Postiz services

set -e

echo "🛑 Stopping Postiz services..."

# Determine which env file to use
if [ -f ".env.production" ]; then
    ENV_FILE=".env.production"
else
    ENV_FILE=".env"
fi

# Stop Docker Compose services
echo "  • Stopping Docker containers..."
docker compose -f docker-compose.prod.yaml --env-file $ENV_FILE down

# Stop any remaining Node.js processes
echo "  • Stopping Node.js processes..."
pkill -f "node.*postiz" || true
pkill -f "pnpm.*start:prod" || true

echo "✅ All services stopped"
