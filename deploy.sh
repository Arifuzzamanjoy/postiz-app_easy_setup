#!/bin/bash

# Postiz Production - Quick Deploy
# This script performs the complete production deployment in one command

set -e

echo "=================================================="
echo "🚀 Postiz Production - Quick Deploy"
echo "=================================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if first-time setup
FIRST_TIME=false
if [ ! -f "apps/backend/dist/main.js" ] || [ ! -f "apps/frontend/.next/BUILD_ID" ]; then
    FIRST_TIME=true
fi

if [ "$FIRST_TIME" = true ]; then
    echo -e "${YELLOW}📦 First-time deployment detected${NC}"
    echo -e "${BLUE}   This will take 15-20 minutes...${NC}"
    echo ""
    
    # Build everything
    echo -e "${BLUE}Step 1/2: Building Postiz...${NC}"
    ./build-production.sh
    
    echo ""
    echo -e "${BLUE}Step 2/2: Starting services...${NC}"
    ./start-production.sh
else
    echo -e "${GREEN}✓ Build artifacts found${NC}"
    echo -e "${BLUE}   Starting services...${NC}"
    ./start-production.sh
fi

echo ""
echo -e "${GREEN}=================================================="
echo -e "✅ Deployment Complete!"
echo -e "==================================================${NC}"
echo ""
echo -e "${BLUE}🌐 Access Postiz at: http://localhost:5000${NC}"
echo ""
