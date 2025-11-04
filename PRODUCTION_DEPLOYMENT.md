# 🚀 Postiz Production Deployment Guide

This guide helps you deploy Postiz in production mode using Docker Compose.

## 📋 Prerequisites

- Docker and Docker Compose installed
- Node.js 22+ and pnpm 10+ installed
- 8GB+ RAM (16GB recommended)
- PostgreSQL and Redis (provided via Docker)
- Domain name (for production HTTPS)

## 🔧 Quick Start

### 1. Configure Environment

```bash
# Copy and edit the production environment file
cp .env.production .env.prod
nano .env.prod
```

**Critical settings to update:**
- `JWT_SECRET` - Generate secure random string: `openssl rand -base64 64`
- `FRONTEND_URL` - Your domain (e.g., `https://postiz.yourdomain.com`)
- `NEXT_PUBLIC_BACKEND_URL` - Your API URL (e.g., `https://postiz.yourdomain.com/api`)
- Social media credentials (Facebook, X, etc.)

### 2. Build Production Images

```bash
# Make scripts executable
chmod +x build-production.sh start-production.sh stop-production.sh

# Build Postiz
./build-production.sh
```

This will:
- Build all Postiz apps (backend, frontend, workers, cron)
- Create Docker image `postiz-app:latest`
- Takes 10-15 minutes

### 3. Start Production Services

```bash
# Start all services
./start-production.sh
```

This will:
- Stop any existing processes
- Run database migrations
- Start all Docker containers
- Perform health checks

### 4. Access Postiz

**Local Development:**
- Main App: http://localhost:5000
- Backend API: http://localhost:3000
- pgAdmin: http://localhost:8081
- RedisInsight: http://localhost:5540

**Production (with domain):**
- Configure your reverse proxy (Nginx/Caddy)
- Set up SSL with Let's Encrypt
- Update `FRONTEND_URL` in `.env.production`

## 📦 Services Architecture

```
┌─────────────────┐
│   Nginx:5000    │ ← Main entry point
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼──┐  ┌──▼────┐
│Backend│  │Frontend│
│ :3000 │  │ :4200  │
└───┬───┘  └────────┘
    │
┌───┴───┐
│Workers│  ← BullMQ job processing
└───┬───┘
    │
┌───┴──┐
│ Cron │  ← Scheduled tasks
└───┬──┘
    │
┌───┴────┬──────┐
│Postgres│ Redis│
└────────┴──────┘
```

## 🔨 Management Commands

### Start/Stop Services

```bash
# Start all services
./start-production.sh

# Stop all services
./stop-production.sh

# Restart a specific service
docker compose -f docker-compose.prod.yaml restart postiz-backend

# Restart all services
docker compose -f docker-compose.prod.yaml restart
```

### View Logs

```bash
# All services
docker compose -f docker-compose.prod.yaml logs -f

# Specific service
docker compose -f docker-compose.prod.yaml logs -f postiz-backend
docker compose -f docker-compose.prod.yaml logs -f postiz-frontend
docker compose -f docker-compose.prod.yaml logs -f postiz-workers

# Nginx access logs
tail -f logs/nginx/access.log
```

### Service Status

```bash
# Check running containers
docker compose -f docker-compose.prod.yaml ps

# Check health
docker compose -f docker-compose.prod.yaml ps
curl http://localhost:3000/health
curl http://localhost:5000
```

### Database Management

```bash
# Access PostgreSQL
docker exec -it postiz-postgres psql -U postiz-prod -d postiz-db-prod

# Run migrations
pnpm run prisma-db-push

# Generate Prisma client
pnpm run prisma-generate

# Database backup
docker exec postiz-postgres pg_dump -U postiz-prod postiz-db-prod > backup.sql

# Database restore
docker exec -i postiz-postgres psql -U postiz-prod postiz-db-prod < backup.sql
```

## 🌐 Production Setup with Domain

### Option 1: Nginx Reverse Proxy (Recommended)

1. **Install Nginx:**
```bash
sudo apt update
sudo apt install nginx certbot python3-certbot-nginx
```

2. **Create Nginx config:**
```nginx
# /etc/nginx/sites-available/postiz
server {
    listen 80;
    server_name postiz.yourdomain.com;
    
    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name postiz.yourdomain.com;
    
    # SSL certificates (managed by certbot)
    ssl_certificate /etc/letsencrypt/live/postiz.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/postiz.yourdomain.com/privkey.pem;
    
    # SSL settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    client_max_body_size 2G;
    
    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_buffering off;
    }
}
```

3. **Enable and get SSL:**
```bash
sudo ln -s /etc/nginx/sites-available/postiz /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
sudo certbot --nginx -d postiz.yourdomain.com
```

4. **Update Postiz config:**
```bash
# Edit .env.production
FRONTEND_URL="https://postiz.yourdomain.com"
NEXT_PUBLIC_BACKEND_URL="https://postiz.yourdomain.com/api"
```

5. **Restart Postiz:**
```bash
./stop-production.sh
./start-production.sh
```

### Option 2: Caddy (Automatic HTTPS)

1. **Install Caddy:**
```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy
```

2. **Create Caddyfile:**
```
postiz.yourdomain.com {
    reverse_proxy localhost:5000
}
```

3. **Start Caddy:**
```bash
sudo systemctl restart caddy
```

## 🔒 Security Checklist

- [ ] Change `JWT_SECRET` to a secure random string
- [ ] Update database credentials in `.env.production`
- [ ] Enable HTTPS with valid SSL certificate
- [ ] Configure firewall (UFW/iptables)
- [ ] Set up regular database backups
- [ ] Enable `RESEND_API_KEY` for email verification (optional)
- [ ] Review and limit exposed ports
- [ ] Set strong passwords for pgAdmin and RedisInsight
- [ ] Configure Cloudflare R2 for file uploads (recommended)

## 🐛 Troubleshooting

### Services Won't Start

```bash
# Check Docker logs
docker compose -f docker-compose.prod.yaml logs

# Check individual service
docker logs postiz-backend

# Verify environment file
grep -E "^(DATABASE_URL|REDIS_URL|JWT_SECRET)" .env.production

# Check port conflicts
sudo lsof -i :3000
sudo lsof -i :4200
sudo lsof -i :5000
```

### Database Connection Issues

```bash
# Test PostgreSQL connection
docker exec postiz-postgres psql -U postiz-prod -d postiz-db-prod -c "SELECT 1;"

# Check database logs
docker logs postiz-postgres

# Verify DATABASE_URL format
echo $DATABASE_URL
```

### Redis Connection Issues

```bash
# Test Redis connection
docker exec postiz-redis redis-cli ping

# Check Redis logs
docker logs postiz-redis
```

### Build Failures

```bash
# Clean and rebuild
rm -rf node_modules apps/*/dist apps/frontend/.next
pnpm install
./build-production.sh

# Check available memory
free -h

# Increase Node.js memory
NODE_OPTIONS="--max-old-space-size=8192" ./build-production.sh
```

### OAuth Redirect Issues

1. Update OAuth redirect URIs in provider dashboards:
   - Facebook: https://developers.facebook.com/apps/YOUR_APP_ID
   - X: https://developer.x.com/en/portal/dashboard

2. Redirect URIs should match:
   - `https://yourdomain.com/integrations/social/facebook`
   - `https://yourdomain.com/integrations/social/instagram`
   - `https://yourdomain.com/integrations/social/x`

## 📊 Monitoring

### Health Checks

```bash
# Backend health
curl http://localhost:3000/health

# Frontend health
curl http://localhost:4200

# Nginx health
curl http://localhost:5000
```

### Resource Usage

```bash
# Docker stats
docker stats

# Specific container
docker stats postiz-backend

# System resources
htop
free -h
df -h
```

## 🔄 Updates

### Update Postiz

```bash
# Pull latest code
git pull origin main

# Rebuild
./build-production.sh

# Restart services
./stop-production.sh
./start-production.sh
```

### Backup Before Update

```bash
# Backup database
docker exec postiz-postgres pg_dump -U postiz-prod postiz-db-prod > backup-$(date +%Y%m%d).sql

# Backup environment
cp .env.production .env.production.backup

# Backup uploads
tar -czf uploads-backup-$(date +%Y%m%d).tar.gz uploads/
```

## 📚 Additional Resources

- [Postiz Documentation](https://docs.postiz.com)
- [Social Credentials Setup](./SOCIAL_CREDENTIALS_SETUP.md)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)

## 🆘 Support

- GitHub Issues: https://github.com/gitroomhq/postiz-app/issues
- Discord: https://discord.postiz.com
- Documentation: https://docs.postiz.com

---

**Version:** 1.0  
**Last Updated:** November 1, 2025  
**For:** Postiz Production Deployment
