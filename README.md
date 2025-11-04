<p align="center">
  <a href="https://github.com/growchief/growchief">
    <img alt="automate" src="https://github.com/user-attachments/assets/d760188d-8d56-4b05-a6c1-c57e67ef25cd" />
  </a>
</p>

<p align="center">
  <a href="https://postiz.com/" target="_blank">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/765e9d72-3ee7-4a56-9d59-a2c9befe2311">
    <img alt="Postiz Logo" src="https://github.com/user-attachments/assets/f0d30d70-dddb-4142-8876-e9aa6ed1cb99" width="280"/>
  </picture>
  </a>
</p>

<p align="center">
<a href="https://opensource.org/license/agpl-v3">
  <img src="https://img.shields.io/badge/License-AGPL%203.0-blue.svg" alt="License">
</a>
</p>

<div align="center">
  <strong>
  <h2>Your ultimate AI social media scheduling tool</h2><br />
  <a href="https://postiz.com">Postiz</a>: An alternative to: Buffer.com, Hypefury, Twitter Hunter, etc...<br /><br />
  </strong>
  Postiz offers everything you need to manage your social media posts,<br />build an audience, capture leads, and grow your business.
</div>

<div class="flex" align="center">
  <br />
  <a href="#-quick-deployment">Quick Deployment</a> •
  <a href="PRODUCTION_DEPLOYMENT.md">Production Setup</a> •
  <a href="CODEBASE_STRUCTURE.md">Architecture</a>
  <br /><br />
</div>

---

## 🚀 Quick Deployment

Deploy Postiz on any Ubuntu server in **under 5 minutes**:

```bash
# 1. Clone this repository
git clone https://github.com/Arifuzzamanjoy/postiz-app_easy_setup.git
cd postiz-app_easy_setup

# 2. Copy and configure environment
cp .env.example .env
nano .env  # Update with your settings (SERVER_IP, credentials, etc.)

# 3. Deploy with one command
chmod +x deploy.sh
./deploy.sh

# 4. Access Postiz
# Open: http://YOUR_SERVER_IP:5000
```

### 📋 Requirements
- **Ubuntu 22.04+** or similar Linux distribution
- **Docker** and **Docker Compose** installed
- **Node.js 20+** and **pnpm 8+**
- **2GB RAM** minimum (4GB recommended)
- **Port 5000** open in firewall

### 📚 Documentation
- **[Production Deployment Guide](PRODUCTION_DEPLOYMENT.md)** - Complete setup instructions
- **[Codebase Structure](CODEBASE_STRUCTURE.md)** - Architecture and code organization
- **[Facebook/Instagram OAuth Setup](facebook-oauth-setup.md)** - Social media integration

### ⚙️ Configuration
Edit `.env` file with your settings:
```bash
# Your server's public IP or domain
FRONTEND_URL="http://YOUR_SERVER_IP:5000"

# Database (uses included PostgreSQL)
DATABASE_URL="postgresql://postiz-local:postiz-local-pwd@localhost:5432/postiz-db-local"

# For HTTP deployments (required for testing without SSL)
NOT_SECURED=true

# Facebook/Instagram OAuth (optional)
FACEBOOK_APP_ID="your-facebook-app-id"
FACEBOOK_APP_SECRET="your-facebook-app-secret"
```

### 🔧 Deployment Scripts
- `deploy.sh` - Full deployment (build + start)
- `build-production.sh` - Build Docker images only
- `start-production.sh` - Start all services
- `stop-production.sh` - Stop all services
- `diagnose-oauth.sh` - Test OAuth configuration

### ✅ Verified Working Configuration
- ✅ External IP access
- ✅ HTTP mode (no SSL required for testing)
- ✅ Facebook/Instagram OAuth integration
- ✅ Database migrations automated
- ✅ Redis queue processing
- ✅ Background workers and cron jobs

---

<div class="flex" align="center">
  <br />
  <img alt="Instagram" src="https://postiz.com/svgs/socials/Instagram.svg" width="32">
  <img alt="Youtube" src="https://postiz.com/svgs/socials/Youtube.svg" width="32">
  <img alt="Dribbble" src="https://postiz.com/svgs/socials/Dribbble.svg" width="32">
  <img alt="Linkedin" src="https://postiz.com/svgs/socials/Linkedin.svg" width="32">
  <img alt="Reddit" src="https://postiz.com/svgs/socials/Reddit.svg" width="32">
  <img alt="TikTok" src="https://postiz.com/svgs/socials/TikTok.svg" width="32">
  <img alt="Facebook" src="https://postiz.com/svgs/socials/Facebook.svg" width="32">
  <img alt="Pinterest" src="https://postiz.com/svgs/socials/Pinterest.svg" width="32">
  <img alt="Threads" src="https://postiz.com/svgs/socials/Threads.svg" width="32">
  <img alt="X" src="https://postiz.com/svgs/socials/X.svg" width="32">
  <img alt="Slack" src="https://postiz.com/svgs/socials/Slack.svg" width="32">
  <img alt="Discord" src="https://postiz.com/svgs/socials/Discord.svg" width="32">
  <img alt="Mastodon" src="https://postiz.com/svgs/socials/Mastodon.svg" width="32">
  <img alt="Bluesky" src="https://postiz.com/svgs/socials/Bluesky.svg" width="32">
</div>

<p align="center">
  <br />
  <a href="https://docs.postiz.com" rel="dofollow"><strong>Explore the docs »</strong></a>
  <br />

  <br />
  <a href="https://youtube.com/@postizofficial" rel="dofollow"><strong>Watch the YouTube Tutorials»</strong></a>
  <br />
</p>

<p align="center">
  <a href="https://platform.postiz.com">Register</a>
  ·
  <a href="https://discord.postiz.com">Join Our Discord (devs only)</a>
  ·
  <a href="https://docs.postiz.com/public-api">Public API</a><br />
</p>
<p align="center">
  <a href="https://www.npmjs.com/package/@postiz/node">NodeJS SDK</a>
  ·
  <a href="https://www.npmjs.com/package/n8n-nodes-postiz">N8N custom node</a>
  ·
  <a href="https://apps.make.com/postiz">Make.com integration</a>
</p>


<br />

<p align="center">
  <video src="https://github.com/user-attachments/assets/05436a01-19c8-4827-b57f-05a5e7637a67" width="100%" />
</p>

## ✨ Features

| ![Image 1](https://github.com/user-attachments/assets/a27ee220-beb7-4c7e-8c1b-2c44301f82ef) | ![Image 2](https://github.com/user-attachments/assets/eb5f5f15-ed90-47fc-811c-03ccba6fa8a2) |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| ![Image 3](https://github.com/user-attachments/assets/d51786ee-ddd8-4ef8-8138-5192e9cfe7c3) | ![Image 4](https://github.com/user-attachments/assets/91f83c89-22f6-43d6-b7aa-d2d3378289fb) |

# Intro

- Schedule all your social media posts (many AI features)
- Measure your work with analytics.
- Collaborate with other team members to exchange or buy posts.
- Invite your team members to collaborate, comment, and schedule posts.
- At the moment there is no difference between the hosted version to the self-hosted version

## Tech Stack

- NX (Monorepo)
- NextJS (React)
- NestJS
- Prisma (Default to PostgreSQL)
- Redis (BullMQ)
- Resend (email notifications)

## Quick Start

To have the project up and running, please follow the [Quick Start Guide](https://docs.postiz.com/quickstart)

## Sponsor Postiz

We now give a few options to Sponsor Postiz:
- Just a donation: You like what we are building, and want to buy us some coffees so we can build faster.
- Main Repository: Get your logo with a backlink from the main Postiz repository. Postiz has almost 3m downloads and 20k views per month.
- Main Repository + Website: Get your logo on the central repository and the main website. Here are some metrics: - Website has 20k hits per month + 65 DR (strong backlink) - Repository has 20k hits per month + Almost 3m docker downloads.

Link: https://opencollective.com/postiz

## Postiz Compliance

- Postiz is an open-source, self-hosted social media scheduling tool that supports platforms like X (formerly Twitter), Bluesky, Mastodon, Discord, and others.
- Postiz hosted service uses official, platform-approved OAuth flows.
- Postiz does not automate or scrape content from social media platforms.
- Postiz does not collect, store, or proxy API keys or access tokens from users.
- Postiz never ask users to paste API keys into our hosted product.
- Postiz Users always authenticate directly with the social platform (e.g., X, Discord, etc.), ensuring platform compliance and data privacy.

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=gitroomhq/postiz-app&type=Date)](https://www.star-history.com/#gitroomhq/postiz-app&Date)

## License

This repository's source code is available under the [AGPL-3.0 license](LICENSE).

<br /><br /><br />

<p align="center">
  <a href="https://www.g2.com/products/postiz/take_survey" target="blank"><img alt="g2" src="https://github.com/user-attachments/assets/892cb74c-0b49-4589-b2f5-fbdbf7a98f66" /></a>
</p>
