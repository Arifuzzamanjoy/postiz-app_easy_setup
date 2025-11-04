#!/bin/bash

# Postiz Production Build Script
# This script builds all Postiz applications for production deployment

set -e  # Exit on any error

echo "=================================================="
echo "🚀 Postiz Production Build Script"
echo "=================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Error: package.json not found. Please run this script from the Postiz root directory.${NC}"
    exit 1
fi

# Check Node.js version
echo -e "${BLUE}📋 Checking Node.js version...${NC}"
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
    echo -e "${RED}❌ Error: Node.js version 22 or higher is required. Current version: $(node -v)${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js version: $(node -v)${NC}"

# Check pnpm installation
echo -e "${BLUE}📋 Checking pnpm installation...${NC}"
if ! command -v pnpm &> /dev/null; then
    echo -e "${RED}❌ Error: pnpm is not installed. Installing pnpm...${NC}"
    npm install -g pnpm@10.6.1
fi
echo -e "${GREEN}✓ pnpm version: $(pnpm -v)${NC}"

# Check available memory
echo -e "${BLUE}📋 Checking available memory...${NC}"
AVAILABLE_MEM=$(free -g | awk '/^Mem:/{print $7}')
if [ "$AVAILABLE_MEM" -lt 4 ]; then
    echo -e "${YELLOW}⚠️  Warning: Less than 4GB memory available. Build might be slow or fail.${NC}"
    echo -e "${YELLOW}   Consider freeing up memory or increasing swap space.${NC}"
fi

# Clean previous builds
echo ""
echo -e "${BLUE}🧹 Cleaning previous builds...${NC}"
rm -rf apps/backend/dist
rm -rf apps/frontend/.next
rm -rf apps/workers/dist
rm -rf apps/cron/dist
echo -e "${GREEN}✓ Previous builds cleaned${NC}"

# Install dependencies
echo ""
echo -e "${BLUE}📦 Installing dependencies...${NC}"
pnpm install --frozen-lockfile
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Generate Prisma client
echo ""
echo -e "${BLUE}🔧 Generating Prisma client...${NC}"
pnpm run prisma-generate
echo -e "${GREEN}✓ Prisma client generated${NC}"

# Build Backend
echo ""
echo -e "${BLUE}🔨 Building Backend (NestJS)...${NC}"
NODE_OPTIONS="--max-old-space-size=4096" pnpm run build:backend
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backend build completed${NC}"
else
    echo -e "${RED}❌ Backend build failed${NC}"
    exit 1
fi

# Build Frontend
echo ""
echo -e "${BLUE}🔨 Building Frontend (Next.js)...${NC}"
NODE_OPTIONS="--max-old-space-size=4096" pnpm run build:frontend
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Frontend build completed${NC}"
else
    echo -e "${RED}❌ Frontend build failed${NC}"
    exit 1
fi

# Build Workers
echo ""
echo -e "${BLUE}🔨 Building Workers...${NC}"
NODE_OPTIONS="--max-old-space-size=4096" pnpm run build:workers
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Workers build completed${NC}"
else
    echo -e "${RED}❌ Workers build failed${NC}"
    exit 1
fi

# Build Cron
echo ""
echo -e "${BLUE}🔨 Building Cron...${NC}"
NODE_OPTIONS="--max-old-space-size=4096" pnpm run build:cron
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Cron build completed${NC}"
else
    echo -e "${RED}❌ Cron build failed${NC}"
    exit 1
fi

# Build Docker image
echo ""
echo -e "${BLUE}🐳 Building Docker image...${NC}"
echo -e "${YELLOW}   This may take 10-15 minutes...${NC}"
NEXT_PUBLIC_VERSION=$(cat version.txt 2>/dev/null || echo "2.0.0")
docker build \
    --build-arg NEXT_PUBLIC_VERSION=$NEXT_PUBLIC_VERSION \
    --tag postiz-app:latest \
    --tag postiz-app:$NEXT_PUBLIC_VERSION \
    -f Dockerfile.dev \
    .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Docker image built successfully${NC}"
    echo -e "${GREEN}  Tagged as: postiz-app:latest and postiz-app:$NEXT_PUBLIC_VERSION${NC}"
else
    echo -e "${RED}❌ Docker image build failed${NC}"
    exit 1
fi

# Summary
echo ""
echo "=================================================="
echo -e "${GREEN}✅ Build completed successfully!${NC}"
echo "=================================================="
echo ""
echo "📦 Built applications:"
echo "  • Backend:  apps/backend/dist"
echo "  • Frontend: apps/frontend/.next"
echo "  • Workers:  apps/workers/dist"
echo "  • Cron:     apps/cron/dist"
echo ""
echo "🐳 Docker image: postiz-app:latest"
echo ""
echo "📚 Next steps:"
echo "  1. Review and update .env.production with your settings"
echo "  2. Run: ./start-production.sh"
echo ""
