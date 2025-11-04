#!/bin/bash
# Optimized Postiz Development Startup Script
# Addresses OOM issues by limiting memory per service

echo "🚀 Starting Postiz Development Environment"
echo "================================================"
echo ""

# Set Node.js memory limits to prevent OOM
export NODE_OPTIONS="--max-old-space-size=1536"

# Check if services are running
check_services() {
    echo "Checking required services..."
    docker ps | grep -q "postiz-postgres" || {
        echo "❌ PostgreSQL not running. Starting Docker services..."
        docker compose -f ./docker-compose.dev.yaml up -d
        sleep 5
    }
    echo "✅ Docker services running"
}

# Kill any existing processes
cleanup() {
    echo "🧹 Cleaning up existing processes..."
    pkill -f "nest start" 2>/dev/null
    pkill -f "next dev" 2>/dev/null
    sleep 2
}

# Start services with staggered timing to reduce memory spikes
start_services() {
    echo ""
    echo "📦 Starting services with memory optimization..."
    echo ""
    
    # Start extension (lightest)
    echo "1/5 Starting Extension..."
    NODE_OPTIONS="--max-old-space-size=512" pnpm --filter ./apps/extension run dev > /tmp/postiz-extension.log 2>&1 &
    sleep 2
    
    # Start workers
    echo "2/5 Starting Workers..."
    NODE_OPTIONS="--max-old-space-size=1024" pnpm --filter ./apps/workers run dev > /tmp/postiz-workers.log 2>&1 &
    sleep 3
    
    # Start cron (with reduced memory)
    echo "3/5 Starting Cron..."
    NODE_OPTIONS="--max-old-space-size=768" pnpm --filter ./apps/cron run dev > /tmp/postiz-cron.log 2>&1 &
    sleep 3
    
    # Start backend
    echo "4/5 Starting Backend..."
    NODE_OPTIONS="--max-old-space-size=2048" pnpm --filter ./apps/backend run dev > /tmp/postiz-backend.log 2>&1 &
    sleep 5
    
    # Start frontend (last, as it's heavy)
    echo "5/5 Starting Frontend..."
    NODE_OPTIONS="--max-old-space-size=2048" pnpm --filter ./apps/frontend run dev > /tmp/postiz-frontend.log 2>&1 &
    
    echo ""
    echo "⏳ Waiting for services to initialize..."
    sleep 10
}

# Monitor services
monitor() {
    echo ""
    echo "📊 Service Status:"
    echo "================================================"
    ps aux | grep -E "(nest|next|vite)" | grep -v grep | awk '{printf "- %-20s: %6s MB (PID: %s)\n", $11, int($6/1024), $2}' | head -10
    echo ""
    echo "💾 Memory Usage:"
    free -h | grep -E "Mem|Swap"
    echo ""
    echo "================================================"
    echo "✅ Postiz is starting!"
    echo ""
    echo "📝 Service URLs:"
    echo "   - Frontend: http://localhost:4200"
    echo "   - Backend:  http://localhost:3000"
    echo ""
    echo "📋 Logs located at:"
    echo "   - Extension: tail -f /tmp/postiz-extension.log"
    echo "   - Workers:   tail -f /tmp/postiz-workers.log"
    echo "   - Cron:      tail -f /tmp/postiz-cron.log"
    echo "   - Backend:   tail -f /tmp/postiz-backend.log"
    echo "   - Frontend:  tail -f /tmp/postiz-frontend.log"
    echo ""
    echo "🛑 To stop all services: pkill -f 'nest start|next dev|vite'"
}

# Main execution
check_services
cleanup
start_services
monitor

echo "Press Ctrl+C to view logs or exit..."
sleep 5

# Show combined logs
tail -f /tmp/postiz-*.log
