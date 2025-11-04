# Postiz Codebase Structure Guide

> **Last Updated**: November 1, 2025  
> **Version**: 1.47.0  
> **Architecture**: NX Monorepo with TypeScript

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Technology Stack](#technology-stack)
3. [Monorepo Structure](#monorepo-structure)
4. [Applications (apps/)](#applications)
5. [Shared Libraries (libraries/)](#shared-libraries)
6. [Database Architecture](#database-architecture)
7. [Social Media Integrations](#social-media-integrations)
8. [Key Workflows](#key-workflows)
9. [Development Guide](#development-guide)
10. [Deployment Architecture](#deployment-architecture)

---

## 🎯 Overview

**Postiz** is an open-source social media management platform that allows users to:
- Schedule posts across 15+ social media platforms
- Use AI-powered content generation
- Collaborate with team members
- Analyze performance with built-in analytics
- Manage multiple organizations/clients

**License**: AGPL-3.0  
**Repository**: https://github.com/gitroomhq/postiz-app

---

## 🛠️ Technology Stack

### Core Technologies
| Technology | Purpose | Version |
|------------|---------|---------|
| **NX** | Monorepo management | Latest |
| **Node.js** | Runtime environment | 20.17.0+ |
| **pnpm** | Package manager | 10.6.1 |
| **TypeScript** | Programming language | 5.5.4 |

### Frontend Stack
| Technology | Purpose |
|------------|---------|
| **Next.js** | React framework (App Router) | 14.2.33 |
| **React** | UI library | 18.3.1 |
| **TailwindCSS** | Styling | 3.4.17 |
| **Zustand** | State management | 5.0.5 |
| **SWR** | Data fetching | 2.2.5 |
| **Mantine** | UI components | 5.10.5 |
| **TipTap** | Rich text editor | 3.0.6 |

### Backend Stack
| Technology | Purpose |
|------------|---------|
| **NestJS** | Backend framework | 10.0.2 |
| **Prisma** | ORM | 6.5.0 |
| **PostgreSQL** | Primary database | Default |
| **Redis** | Caching & queues | Via ioredis |
| **BullMQ** | Job queue system | 5.12.12 |

### Infrastructure
| Service | Purpose |
|---------|---------|
| **Sentry** | Error tracking | 10.12.0 |
| **Resend** | Email delivery | 3.2.0 |
| **Stripe** | Payments | 15.5.0 |
| **Cloudflare R2** | File storage | Optional |

---

## 📁 Monorepo Structure

```
postiz-app/
├── apps/                      # Main applications
│   ├── backend/              # NestJS API server
│   ├── frontend/             # Next.js web application
│   ├── workers/              # Background job processors
│   ├── cron/                 # Scheduled tasks
│   ├── commands/             # CLI commands
│   ├── extension/            # Browser extension
│   └── sdk/                  # Public SDK
│
├── libraries/                 # Shared code
│   ├── nestjs-libraries/     # Backend shared modules
│   ├── react-shared-libraries/ # Frontend shared components
│   └── helpers/              # Common utilities
│
├── var/docker/               # Docker configs
├── Jenkins/                  # CI/CD pipelines
└── uploads/                  # Local file storage
```

---

## 🚀 Applications

### 1. Backend (`apps/backend/`)

**Framework**: NestJS  
**Port**: 3000  
**Entry Point**: `src/main.ts`

#### Structure

```
apps/backend/src/
├── main.ts                   # Application bootstrap
├── app.module.ts             # Root module
│
├── api/                      # Protected API endpoints
│   ├── api.module.ts
│   └── routes/
│       ├── auth.controller.ts       # Authentication
│       ├── posts.controller.ts      # Post management
│       ├── integrations.controller.ts # Social connections
│       ├── analytics.controller.ts   # Analytics data
│       ├── users.controller.ts       # User management
│       ├── media.controller.ts       # File uploads
│       ├── billing.controller.ts     # Stripe integration
│       ├── settings.controller.ts    # Settings
│       ├── notifications.controller.ts
│       ├── autopost.controller.ts    # Scheduled posts
│       ├── sets.controller.ts        # Post sets
│       ├── agencies.controller.ts    # Multi-client
│       ├── marketplace.controller.ts # Post exchange
│       ├── copilot.controller.ts     # AI features
│       ├── messages.controller.ts    # Messaging
│       ├── third-party.controller.ts # External integrations
│       └── webhooks.controller.ts    # Webhook handlers
│
├── public-api/               # Public API (rate-limited)
│   └── routes/v1/
│       └── public.integrations.controller.ts
│
└── services/                 # Business logic
    └── auth/
        └── permissions/      # RBAC implementation
```

#### Key API Modules

| Module | Purpose |
|--------|---------|
| **ApiModule** | Protected endpoints (JWT auth) |
| **PublicApiModule** | Public API with rate limiting |
| **DatabaseModule** | Prisma ORM integration |
| **BullMqModule** | Job queue management |
| **AgentModule** | AI agent functionality |
| **VideoModule** | Video processing |
| **ChatModule** | Real-time messaging |

#### Authentication Flow

```typescript
// Guard chain
ThrottlerGuard → JWTAuth → PoliciesGuard → Controller
                              ↓
                    Check user permissions (RBAC)
```

---

### 2. Frontend (`apps/frontend/`)

**Framework**: Next.js 14 (App Router)  
**Port**: 4200  
**Entry Point**: `src/app/layout.tsx`

#### Structure

```
apps/frontend/src/
├── app/                      # Next.js App Router
│   ├── (app)/               # Main application routes
│   │   ├── launches/        # Post scheduler
│   │   ├── analytics/       # Analytics dashboard
│   │   ├── settings/        # Settings pages
│   │   ├── marketplace/     # Content marketplace
│   │   └── auth/            # Authentication pages
│   │
│   ├── layout.tsx           # Root layout
│   ├── middleware.ts        # Route protection
│   └── instrumentation.ts   # Sentry setup
│
└── components/              # Shared React components
    ├── launches/            # Post editor
    ├── analytics/           # Charts & stats
    ├── settings/            # Settings UI
    └── media/               # Media library
```

#### State Management

```typescript
// Zustand stores
stores/
├── user.store.ts           # User data
├── organization.store.ts   # Current org
├── integrations.store.ts   # Social accounts
└── posts.store.ts          # Draft posts
```

#### Key Features

| Feature | Implementation |
|---------|----------------|
| **Post Editor** | TipTap rich text + media upload |
| **Scheduling** | Calendar + time picker UI |
| **Analytics** | Chart.js visualizations |
| **Media Library** | Uppy + S3/R2 integration |
| **AI Content** | OpenAI GPT-4 integration |
| **Real-time** | SWR for data fetching |

---

### 3. Workers (`apps/workers/`)

**Purpose**: Background job processing  
**Framework**: NestJS microservice  
**Queue**: BullMQ + Redis

#### Job Types

```typescript
// apps/workers/src/app/
workers/
├── post.worker.ts           # Publish scheduled posts
├── analytics.worker.ts      # Fetch analytics data
├── refresh.worker.ts        # Refresh social tokens
├── notification.worker.ts   # Send notifications
└── video.worker.ts          # Process videos
```

#### Processing Flow

```
1. Backend → Add job to Redis queue
2. Workers → Pick up job from queue
3. Workers → Execute (e.g., publish post to social API)
4. Workers → Update database with result
5. Workers → Send notification to user
```

---

### 4. Cron (`apps/cron/`)

**Purpose**: Scheduled background tasks  
**Framework**: NestJS with `@nestjs/schedule`

#### Tasks

```typescript
// apps/cron/src/tasks/
├── refresh-tokens.task.ts   # Refresh OAuth tokens
├── clean-old-data.task.ts   # Database cleanup
├── analytics-sync.task.ts   # Sync analytics
└── trial-check.task.ts      # Check trial expirations
```

#### Schedule Examples

```typescript
@Cron('0 */6 * * *')  // Every 6 hours
async refreshSocialTokens() {}

@Cron('0 0 * * *')    // Daily at midnight
async cleanOldPosts() {}
```

---

### 5. Extension (`apps/extension/`)

**Purpose**: Browser extension for quick posting  
**Build**: Vite + React  
**Platforms**: Chrome, Firefox

#### Structure

```
apps/extension/src/
├── pages/
│   ├── popup/               # Extension popup
│   ├── options/             # Settings page
│   └── background/          # Service worker
│
├── manifest.json            # Extension manifest
└── custom-vite-plugins.ts   # Build config
```

---

### 6. SDK (`apps/sdk/`)

**Purpose**: Official Node.js SDK  
**Package**: `@postiz/node`  
**Build**: tsup

#### Usage Example

```typescript
import { PostizClient } from '@postiz/node';

const client = new PostizClient({ apiKey: 'xxx' });
await client.posts.create({
  content: 'Hello world!',
  platforms: ['twitter', 'linkedin']
});
```

---

## 📚 Shared Libraries

### 1. nestjs-libraries (`libraries/nestjs-libraries/`)

Shared backend modules used across backend, workers, and cron.

#### Key Modules

```
src/
├── database/                 # Prisma ORM
│   └── prisma/
│       ├── schema.prisma     # Database schema
│       └── database.module.ts
│
├── integrations/             # Social media integrations
│   ├── social.abstract.ts    # Base class
│   ├── integration.manager.ts # Provider factory
│   └── social/
│       ├── facebook.provider.ts
│       ├── instagram.provider.ts
│       ├── instagram.standalone.provider.ts
│       ├── x.provider.ts
│       ├── linkedin.provider.ts
│       ├── youtube.provider.ts
│       ├── tiktok.provider.ts
│       ├── threads.provider.ts
│       ├── reddit.provider.ts
│       ├── pinterest.provider.ts
│       ├── discord.provider.ts
│       ├── slack.provider.ts
│       ├── mastodon.provider.ts
│       ├── bluesky.provider.ts
│       └── ... (15+ providers)
│
├── bull-mq-transport-new/    # BullMQ queue module
├── agent/                    # AI agent system
├── chat/                     # Real-time chat
├── videos/                   # Video processing
├── upload/                   # File upload handling
├── emails/                   # Email templates
├── crypto/                   # Encryption utilities
├── short-linking/            # URL shorteners
├── redis/                    # Redis client
├── sentry/                   # Error tracking
├── throttler/                # Rate limiting
└── user/                     # User utilities
```

#### Integration Architecture

Each social provider implements:

```typescript
interface SocialProvider {
  // OAuth flow
  authenticationFlow(): { url: string, scopes: string[] }
  callback(code: string): Promise<{ accessToken, refreshToken }>
  
  // Post publishing
  post(data: PostDto): Promise<PostResult>
  
  // Analytics
  getAnalytics(): Promise<AnalyticsData>
  
  // Account info
  getAccountInfo(): Promise<AccountInfo>
}
```

---

### 2. react-shared-libraries (`libraries/react-shared-libraries/`)

Shared frontend components and utilities.

```
src/
├── components/              # Reusable UI components
├── hooks/                   # Custom React hooks
├── utils/                   # Frontend utilities
└── types/                   # Shared TypeScript types
```

---

### 3. helpers (`libraries/helpers/`)

Common utilities used by both frontend and backend.

```
src/
├── auth/                    # Auth helpers
├── configuration/           # Config utilities
├── decorators/              # Custom decorators
├── subdomain/               # Multi-tenancy
├── swagger/                 # API documentation
└── utils/                   # General utilities
```

---

## 🗄️ Database Architecture

**ORM**: Prisma  
**Database**: PostgreSQL  
**Schema Location**: `libraries/nestjs-libraries/src/database/prisma/schema.prisma`

### Core Models

#### 1. User & Organizations

```prisma
model User {
  id                String              @id @default(uuid())
  email             String
  password          String?
  providerName      Provider            // LOCAL, GOOGLE, FACEBOOK
  organizations     UserOrganization[]  // Many-to-many
  timezone          Int
  activated         Boolean             @default(true)
  isSuperAdmin      Boolean             @default(false)
}

model Organization {
  id           String              @id @default(uuid())
  name         String
  users        UserOrganization[]
  integrations Integration[]       // Social accounts
  posts        Post[]
  subscription Subscription?
}

model UserOrganization {
  userId         String
  organizationId String
  role           Role               // ADMIN, USER, MEMBER
  disabled       Boolean            @default(false)
  
  @@unique([userId, organizationId])
}
```

#### 2. Social Integrations

```prisma
model Integration {
  id              String      @id @default(uuid())
  name            String      // Platform name
  picture         String?     // Profile picture
  type            String      // facebook, instagram, twitter, etc.
  internalId      String      // Platform account ID
  token           String      // Access token (encrypted)
  refreshToken    String?     // Refresh token (encrypted)
  expiresAt       DateTime?
  tokenInfo       Json?       // Additional token data
  organizationId  String
  organization    Organization @relation(fields: [organizationId])
  posts           Post[]
  disabled        Boolean     @default(false)
}
```

#### 3. Posts & Scheduling

```prisma
model Post {
  id              String       @id @default(uuid())
  content         String       // Post text
  settings        Json         // Platform-specific settings
  group           String?      // Grouping identifier
  state           State        // DRAFT, SCHEDULED, PUBLISHED, ERROR
  publishDate     DateTime?    // When to publish
  submittedForOrderId String?
  organization    Organization @relation("organization")
  integration     Integration[] // Target platforms
  media           PostMedia[]   // Attached media
  comments        Comments[]
  tags            TagsPosts[]
}

model PostMedia {
  id       String @id @default(uuid())
  postId   String
  post     Post   @relation(fields: [postId])
  mediaId  String
  media    Media  @relation(fields: [mediaId])
  order    Int    // Display order
}

model Media {
  id       String @id @default(uuid())
  path     String // S3/R2 path or local path
  type     String // image, video, pdf
  size     Int
  name     String
  orgId    String
}
```

#### 4. Billing & Subscriptions

```prisma
model Subscription {
  id              String       @id @default(uuid())
  organizationId  String       @unique
  subscriptionTier SubscriptionTier // FREE, PRO, TEAM
  period          Period       // MONTHLY, YEARLY
  totalChannels   Int          // Max social accounts
  billingModel    Billing      // STANDARD, METERED
  paymentProvider Provider     // STRIPE, MANUAL
}

model Credits {
  id              String       @id @default(uuid())
  orgId           String
  credits         Int          // AI credits
  totalCredits    Int
}
```

---

## 🌐 Social Media Integrations

### Supported Platforms (15+)

| Platform | OAuth | Posting | Analytics | Notes |
|----------|-------|---------|-----------|-------|
| **Facebook** | ✅ OAuth 2.0 | ✅ | ✅ | Pages & groups |
| **Instagram** | ✅ via Facebook | ✅ | ✅ | Business accounts |
| **Instagram Standalone** | ✅ OAuth 2.0 | ✅ | ❌ | Direct API |
| **X (Twitter)** | ✅ OAuth 2.0 | ✅ | ✅ | v2 API |
| **LinkedIn** | ✅ OAuth 2.0 | ✅ | ✅ | Personal & pages |
| **YouTube** | ✅ OAuth 2.0 | ✅ | ✅ | Videos & shorts |
| **TikTok** | ✅ OAuth 2.0 | ✅ | ✅ | Video uploads |
| **Threads** | ✅ via Facebook | ✅ | ❌ | Meta's platform |
| **Reddit** | ✅ OAuth 2.0 | ✅ | ❌ | Subreddits |
| **Pinterest** | ✅ OAuth 2.0 | ✅ | ❌ | Pins & boards |
| **Discord** | ✅ OAuth 2.0 | ✅ | ❌ | Webhooks |
| **Slack** | ✅ OAuth 2.0 | ✅ | ❌ | Channels |
| **Mastodon** | ✅ OAuth 2.0 | ✅ | ❌ | Decentralized |
| **Bluesky** | ✅ App Password | ✅ | ❌ | AT Protocol |
| **Dribbble** | ✅ OAuth 2.0 | ✅ | ❌ | Shots |

### Integration Flow

```
1. User clicks "Connect [Platform]" in UI
2. Frontend → Backend: GET /integrations/social/[platform]
3. Backend → IntegrationManager → [Platform]Provider
4. Provider generates OAuth URL with scopes
5. User redirects to platform → Authorizes
6. Platform redirects to callback URL
7. Backend exchanges code for access token
8. Backend encrypts & stores token in database
9. Backend creates Integration record
10. Frontend displays connected account
```

### Provider Base Class

```typescript
// libraries/nestjs-libraries/src/integrations/social.abstract.ts

export abstract class SocialAbstract {
  // OAuth
  abstract authenticationFlow(): { url: string, scopes: string[] };
  abstract callback(code: string): Promise<TokenData>;
  
  // Publishing
  abstract post(data: PostDto): Promise<PostResult>;
  
  // Analytics (optional)
  analytics?(): Promise<AnalyticsData>;
  
  // Refresh token (optional)
  refreshToken?(refreshToken: string): Promise<TokenData>;
}
```

---

## 🔄 Key Workflows

### 1. Publishing a Post

```
User creates post in editor
  ↓
Frontend validates content
  ↓
POST /posts → Backend API
  ↓
Backend creates Post record (state: DRAFT)
  ↓
User schedules for later
  ↓
Backend updates Post (state: SCHEDULED, publishDate: xxx)
  ↓
Backend adds job to BullMQ queue
  ↓
Workers pick up job at scheduled time
  ↓
Worker → IntegrationManager.publish(post, platform)
  ↓
Provider calls platform API
  ↓
Worker updates Post (state: PUBLISHED | ERROR)
  ↓
Worker sends notification to user
```

### 2. OAuth Token Refresh

```
Cron job runs every 6 hours
  ↓
Finds Integrations with expiring tokens
  ↓
For each integration:
  ↓
  Provider.refreshToken(refreshToken)
  ↓
  Platform returns new access token
  ↓
  Backend encrypts & updates Integration
```

### 3. Analytics Sync

```
User opens analytics page
  ↓
Frontend: GET /analytics?platform=instagram
  ↓
Backend checks cache (Redis)
  ↓
If cache miss:
  ↓
  Backend adds job to analytics queue
  ↓
  Worker fetches data from platform API
  ↓
  Worker stores in database
  ↓
  Worker updates cache
  ↓
Backend returns analytics data
```

---

## 🏗️ Development Guide

### Prerequisites

```bash
- Node.js 20.17.0 or higher
- pnpm 10.6.1
- PostgreSQL 14+
- Redis 6+
```

### Setup

```bash
# Clone repository
git clone https://github.com/gitroomhq/postiz-app
cd postiz-app

# Install dependencies
pnpm install

# Setup environment
cp .env.example .env
# Edit .env with your config

# Start PostgreSQL & Redis
docker compose -f docker-compose.dev.yaml up -d

# Run database migrations
pnpm run prisma-db-push

# Start all services in dev mode
pnpm run dev
```

### Development Commands

```bash
# Run specific service
pnpm run dev:backend    # Backend API (port 3000)
pnpm run dev:frontend   # Frontend (port 4200)
pnpm run dev:workers    # Background workers
pnpm run dev:cron       # Cron jobs

# Build
pnpm run build          # Build all apps
pnpm run build:backend
pnpm run build:frontend

# Database
pnpm run prisma-generate  # Generate Prisma client
pnpm run prisma-db-push   # Push schema changes
pnpm run prisma-reset     # Reset database

# Testing
pnpm test              # Run all tests
```

### Port Allocation

| Service | Port | URL |
|---------|------|-----|
| Backend | 3000 | http://localhost:3000 |
| Frontend | 4200 | http://localhost:4200 |
| Nginx (prod) | 5000 | http://localhost:5000 |
| PostgreSQL | 5432 | - |
| Redis | 6379 | - |

---

## 🚀 Deployment Architecture

### Production Docker Stack

```yaml
# docker-compose.prod.yaml

services:
  postiz-backend:        # NestJS API
    port: 3000
    depends_on: [postgres, redis]
    
  postiz-frontend:       # Next.js app
    port: 4200
    depends_on: [backend]
    
  postiz-workers:        # Background jobs
    depends_on: [backend, redis]
    
  postiz-cron:          # Scheduled tasks
    depends_on: [backend, redis]
    
  postiz-nginx:         # Reverse proxy
    port: 5000
    depends_on: [frontend, backend]
    
  postiz-postgres:      # Database
    port: 5432
    
  postiz-redis:         # Cache & queues
    port: 6379
```

### Network Flow

```
Internet
  ↓
Nginx (port 5000)
  ↓
  ├→ Frontend (4200) → Static assets
  └→ Backend (3000/api) → API endpoints
      ↓
      ├→ PostgreSQL (5432)
      └→ Redis (6379) → BullMQ queues
          ↓
          ├→ Workers (background jobs)
          └→ Cron (scheduled tasks)
```

### Environment Variables

**Critical Variables:**

```bash
# URLs
MAIN_URL="http://your-domain.com"
FRONTEND_URL="http://your-domain.com"
NEXT_PUBLIC_BACKEND_URL="http://your-domain.com/api"

# Database
DATABASE_URL="postgresql://user:pass@localhost:5432/postiz"
REDIS_URL="redis://localhost:6379"

# Security
JWT_SECRET="your-secret-key"

# Social Media APIs (15+ platforms)
FACEBOOK_APP_ID="..."
FACEBOOK_APP_SECRET="..."
INSTAGRAM_APP_ID="..."
INSTAGRAM_APP_SECRET="..."
X_API_KEY="..."
LINKEDIN_CLIENT_ID="..."
# ... etc

# Optional Services
OPENAI_API_KEY="..."           # AI features
RESEND_API_KEY="..."           # Email
STRIPE_SECRET_KEY="..."        # Payments
CLOUDFLARE_ACCESS_KEY="..."    # File storage
```

---

## 📊 Performance Considerations

### Caching Strategy

```typescript
// Redis caching
- Analytics data: 1 hour TTL
- Social profile info: 6 hours TTL
- OAuth tokens: Until expiry
```

### Queue Processing

```typescript
// BullMQ configuration
- Concurrency: 5 workers per queue
- Retry: 3 attempts with exponential backoff
- Rate limiting: Per platform API limits
```

### Database Optimization

```sql
-- Key indexes
CREATE INDEX idx_posts_publishDate ON Post(publishDate);
CREATE INDEX idx_integration_orgId ON Integration(organizationId);
CREATE INDEX idx_user_email ON User(email, providerName);
```

---

## 🔒 Security Features

### Authentication

- JWT-based authentication
- Refresh token rotation
- OAuth 2.0 for social platforms
- Rate limiting (30 req/hour for public API)

### Data Protection

- Encrypted tokens at rest
- HTTPS in production
- CORS configuration
- SQL injection protection (Prisma)
- XSS protection (sanitized inputs)

### RBAC (Role-Based Access Control)

```typescript
enum Role {
  ADMIN,     // Full access
  USER,      // Standard user
  MEMBER     // Read-only
}

// Guard checks
@CheckPolicies((ability) => ability.can('create', 'Post'))
async createPost() {}
```

---

## 🐛 Debugging

### Sentry Integration

```typescript
// Error tracking enabled in:
- Backend (NestJS)
- Frontend (Next.js)
- Workers
```

### Logging

```typescript
// Console logs in development
// Sentry capture in production

import * as Sentry from '@sentry/nestjs';
Sentry.captureException(error);
```

---

## 📚 Additional Resources

- **Official Docs**: https://docs.postiz.com
- **API Reference**: https://docs.postiz.com/public-api
- **Discord Community**: https://discord.postiz.com
- **YouTube Tutorials**: https://youtube.com/@postizofficial

---

## 🤝 Contributing

1. Read `CONTRIBUTING.md`
2. Follow conventional commits
3. Add tests for new features
4. Update documentation
5. Submit PR with clear description

---

## 📝 License

**AGPL-3.0** - See LICENSE file for details

---

**Generated by**: GitHub Copilot  
**For**: Postiz Production Deployment  
**Contact**: https://postiz.com
