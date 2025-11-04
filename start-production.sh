#!/bin/bash

# Postiz Production Startup Script
# This script manages the production deployment of Postiz

set -e  # Exit on any error

echo "=================================================="
echo "🚀 Postiz Production Startup"
echo "=================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

# Check if .env.production exists
if [ ! -f ".env.production" ]; then
    echo -e "${YELLOW}⚠️  Warning: .env.production not found. Using .env instead.${NC}"
    if [ ! -f ".env" ]; then
        echo -e "${RED}❌ Error: No environment file found. Please create .env or .env.production${NC}"
        exit 1
    fi
    ENV_FILE=".env"
else
    ENV_FILE=".env.production"
    echo -e "${GREEN}✓ Using environment file: $ENV_FILE${NC}"
fi

# Check if Docker image exists
if ! docker image inspect postiz-app:latest > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Docker image 'postiz-app:latest' not found.${NC}"
    echo -e "${BLUE}   Building Docker image first...${NC}"
    ./build-production.sh
fi

# Stop any running Node.js processes
echo ""
echo -e "${BLUE}🛑 Stopping existing Node.js processes...${NC}"
pkill -f "node.*postiz" || true
pkill -f "pnpm.*start:prod" || true
sleep 2
echo -e "${GREEN}✓ Existing processes stopped${NC}"

# Stop existing Docker containers
echo ""
echo -e "${BLUE}🐳 Stopping existing Docker containers...${NC}"
docker compose -f docker-compose.prod.yaml --env-file $ENV_FILE down 2>/dev/null || true
echo -e "${GREEN}✓ Existing containers stopped${NC}"

# Create necessary directories
echo ""
echo -e "${BLUE}📁 Creating necessary directories...${NC}"
mkdir -p logs/nginx
mkdir -p logs/backend
mkdir -p logs/frontend
mkdir -p uploads
echo -e "${GREEN}✓ Directories created${NC}"

# Run database migrations
echo ""
echo -e "${BLUE}🗄️  Running database migrations...${NC}"
echo -e "${YELLOW}   Skipping migrations - will run inside Docker container${NC}"
echo -e "${GREEN}✓ Migrations will be handled by Docker Compose${NC}"

# Start Docker Compose services
echo ""
echo -e "${BLUE}🚀 Starting Postiz services...${NC}"
echo -e "${YELLOW}   This may take a few minutes...${NC}"
docker compose -f docker-compose.prod.yaml --env-file $ENV_FILE up -d

# Wait for services to be healthy
echo ""
echo -e "${BLUE}⏳ Waiting for services to be healthy...${NC}"
sleep 10

# Check service health
echo ""
echo -e "${BLUE}🏥 Checking service health...${NC}"

check_service() {
    SERVICE=$1
    CONTAINER=$2
    URL=$3
    
    echo -n "  • $SERVICE: "
    if docker ps | grep -q "$CONTAINER"; then
        if [ ! -z "$URL" ]; then
            if curl -sf "$URL" > /dev/null 2>&1; then
                echo -e "${GREEN}✓ Running & Healthy${NC}"
            else
                echo -e "${YELLOW}⚠️  Running but not responding${NC}"
            fi
        else
            echo -e "${GREEN}✓ Running${NC}"
        fi
    else
        echo -e "${RED}❌ Not running${NC}"
    fi
}

check_service "PostgreSQL" "postiz-postgres" ""
check_service "Redis" "postiz-redis" ""
check_service "Backend" "postiz-backend" "http://localhost:3000/health"
check_service "Frontend" "postiz-frontend" "http://localhost:4200"
check_service "Workers" "postiz-workers" ""
check_service "Cron" "postiz-cron" ""
check_service "Nginx" "postiz-nginx" "http://localhost:5000"

# Display access information
echo ""
echo "=================================================="
echo -e "${GREEN}✅ Postiz is now running!${NC}"
echo "=================================================="
echo ""
echo "🌐 Access URLs:"
echo "  • Main Application: http://localhost:5000"
echo "  • Backend API:      http://localhost:3000"
echo "  • Frontend Direct:  http://localhost:4200"
echo "  • pgAdmin:          http://localhost:8081"
echo "  • RedisInsight:     http://localhost:5540"
echo ""
echo "📊 Service Status:"
docker compose -f docker-compose.prod.yaml ps
echo ""
echo "📝 View logs:"
echo "  • All services:   docker compose -f docker-compose.prod.yaml logs -f"
echo "  • Backend:        docker compose -f docker-compose.prod.yaml logs -f postiz-backend"
echo "  • Frontend:       docker compose -f docker-compose.prod.yaml logs -f postiz-frontend"
echo "  • Workers:        docker compose -f docker-compose.prod.yaml logs -f postiz-workers"
echo "  • Nginx:          tail -f logs/nginx/access.log"
echo ""
echo "🛑 Stop services:"
echo "  docker compose -f docker-compose.prod.yaml down"
echo ""
echo "🔄 Restart services:"
echo "  docker compose -f docker-compose.prod.yaml restart"
echo ""
echo "📚 Documentation:"
echo "  • Setup Guide:     cat SOCIAL_CREDENTIALS_SETUP.md"
echo "  • Official Docs:   https://docs.postiz.com"
echo ""

# Offer to show logs
echo -e "${BLUE}Would you like to view the logs? (y/n)${NC}"
read -t 10 -n 1 SHOW_LOGS || SHOW_LOGS="n"
echo ""

if [ "$SHOW_LOGS" = "y" ] || [ "$SHOW_LOGS" = "Y" ]; then
    docker compose -f docker-compose.prod.yaml logs -f
fi
