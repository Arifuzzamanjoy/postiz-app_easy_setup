# 🔐 Instagram & X (Twitter) API Credentials Setup Guide for Postiz

Complete guide for obtaining and configuring Instagram and X (Twitter) API credentials for your Postiz installation.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Instagram Setup](#instagram-setup)
3. [X (Twitter) Setup](#x-twitter-setup)
4. [Configuration](#configuration)
5. [OAuth Flow Explained](#oauth-flow-explained)
6. [Troubleshooting](#troubleshooting)
7. [Official Documentation Links](#official-documentation-links)

---

## Overview

### What You'll Need

**For Instagram:**
- Meta (Facebook) Developer Account (free)
- Instagram Business or Creator Account
- App ID and App Secret

**For X (Twitter):**
- X Developer Account (free, requires approval)
- API Key (Consumer Key)
- API Secret (Consumer Secret)

### Environment Variables Required

```bash
# Instagram
INSTAGRAM_APP_ID="your_app_id_here"
INSTAGRAM_APP_SECRET="your_app_secret_here"

# Facebook (also used for Instagram Business integration)
FACEBOOK_APP_ID="your_facebook_app_id"
FACEBOOK_APP_SECRET="your_facebook_app_secret"

# X (Twitter)
X_API_KEY="your_consumer_key_here"
X_API_SECRET="your_consumer_secret_here"
```

---

## Instagram Setup

### Integration Methods

Postiz supports **TWO** Instagram integration methods:

1. **Instagram Standalone** - Direct Instagram OAuth
   - Requires Instagram Business/Creator account
   - Uses `INSTAGRAM_APP_ID` and `INSTAGRAM_APP_SECRET`

2. **Instagram via Facebook** - Facebook Pages linked to Instagram
   - Uses `FACEBOOK_APP_ID` and `FACEBOOK_APP_SECRET`
   - Provides additional features for business accounts

### Step 1: Create Meta Developer Account

1. Navigate to: **https://developers.facebook.com/**
2. Click **"Get Started"** or **"My Apps"** in the top right corner
3. Log in with your Facebook account
4. Complete account verification if prompted (email/phone verification)

### Step 2: Create a New App

1. Click the **"Create App"** button
2. Select app type:
   - Choose **"Business"** (recommended for most use cases)
   - Or **"Consumer"** if building for personal use only
3. Fill in app details:
   - **App Name**: e.g., "Postiz Social Scheduler" or "My Social Media Manager"
   - **App Contact Email**: Your valid email address
   - **Business Account**: Select existing or create new business account
4. Click **"Create App"**
5. Complete security check if prompted

### Step 3: Add Instagram Product

1. In your app dashboard, scroll to the **"Add Products"** section
2. Find **"Instagram"** and click **"Set Up"**
3. Choose Instagram API type:

   **Option A: Instagram Basic Display API** (Personal accounts)
   - Supports basic profile access
   - Limited to personal Instagram accounts
   - Good for read-only access

   **Option B: Instagram Graph API** (Business/Creator accounts) ✅ **RECOMMENDED**
   - Full content publishing capabilities
   - Required for business posting features
   - Required for automated scheduling
   - Postiz uses this for content scheduling

### Step 4: Configure Instagram Product

1. Navigate to **Instagram → Basic Display** (or Instagram Graph API)
2. Click **"Create New App"**
3. Set up OAuth Redirect URIs:

   **For Instagram Standalone:**
   ```
   http://localhost:4200/integrations/social/instagram-standalone
   ```
   
   **For Instagram via Facebook:**
   ```
   http://localhost:4200/integrations/social/instagram
   ```
   
   **For Production:** Replace `localhost:4200` with your actual domain:
   ```
   https://yourdomain.com/integrations/social/instagram-standalone
   https://yourdomain.com/integrations/social/instagram
   ```

4. Add **Deauthorize Callback URL**: Use same as redirect URI
5. Add **Data Deletion Request URL**: Use same as redirect URI

### Step 5: Get Your Credentials

1. Navigate to **Settings → Basic** in the left sidebar
2. Find the credentials section at the top:
   - **App ID** → Copy this numeric value (16 digits)
   - **App Secret** → Click "Show" button, then copy the value
3. Save these credentials securely!
   - Consider using a password manager
   - Never commit these to public repositories

### Step 6: Configure Permissions

Required scopes (automatically requested by Postiz):
- `instagram_business_basic` - Access to basic account information
- `instagram_business_content_publish` - Publish posts, stories, reels
- `instagram_business_manage_comments` - Manage post comments
- `instagram_business_manage_insights` - Access analytics data

### Step 7: App Review (For Production Use)

⚠️ **Important for public/production use:**

1. Go to **App Review** → **Permissions and Features**
2. Request the following permissions:
   - `instagram_content_publish`
   - `pages_read_engagement`
   - `pages_manage_posts`
3. Provide detailed use case description:
   - Explain you're building a social media scheduling tool
   - Describe how you'll use each permission
   - Include screenshots or demo video if available
4. Submit for review
5. Wait for approval (typically 3-7 business days)

**Development Mode:**
- You can test with your own account without approval
- Add test users in **Roles → Test Users**
- Limited to test users only until app is approved

---

## X (Twitter) Setup

### Overview

X uses OAuth 1.0a authentication requiring:
- **API Key** (also called Consumer Key)
- **API Secret** (also called Consumer Secret)

### Step 1: Apply for X Developer Account

1. Navigate to: **https://developer.x.com/**
2. Click **"Sign up"** or **"Apply"** button
3. Log in with your X (Twitter) account
4. Complete the application form:
   
   **Account Details:**
   - Verify your email address
   - Verify phone number (SMS verification)
   
   **Use Case Selection:**
   - Select **"Building tools for your own use"** or
   - Select **"Exploring the API"** for development
   
   **Description:**
   - Explain: "Building a social media scheduling and automation tool"
   - Mention: "Will use API to post tweets on behalf of authenticated users"
   
   **Will you make X content available?**
   - Select "No" (unless you plan to display tweets externally)

5. Accept the **Developer Agreement**
6. Submit application
7. Wait for approval (usually instant to 24 hours)
   - Check your email for approval notification

### Step 2: Create a Project (Required for v2 API)

1. In the Developer Portal, go to **"Projects & Apps"** in the sidebar
2. Click **"+ Add Project"** (or "Create Project")
3. Fill in project details:
   - **Project Name**: e.g., "Postiz Scheduler" or "Social Media Manager"
   - **Use case**: Choose "Making a bot" or "Exploring the API"
   - **Project description**: Brief description of your use case
4. Click **"Next"**

### Step 3: Create an App

1. Within your project, click **"+ Add App"**
   - Or go to **"Standalone Apps"** → **"+ Create App"**
2. Enter app details:
   - **App Name**: e.g., "postiz-local-dev" or "postiz-production"
   - **Environment**: Choose "Development" or "Production"
3. Click **"Next"** or **"Complete"**

### Step 4: Save Your API Keys

⚠️ **CRITICAL**: Keys are displayed ONLY ONCE! Save them immediately!

Upon app creation, you'll immediately see:
- **API Key** (Consumer Key) → ~25 characters
- **API Secret** (Consumer Secret) → ~50 characters
- **Bearer Token** → Optional for OAuth 1.0a (save it anyway)

**Important:**
- Copy these to a secure location immediately
- Store in password manager or secure notes
- If you lose them, you'll need to regenerate (old keys will stop working)

### Step 5: Configure App Settings

1. Go to your app dashboard
2. Click the **"Settings"** tab
3. Scroll to **"User authentication settings"** section
4. Click **"Set up"** button

### Step 6: Enable OAuth 1.0a

1. In User authentication settings configuration:

   **App Permissions:**
   - Select **"Read and write"** ✅ (Required for posting)
   - Do NOT select "Read only"
   
   **Type of App:**
   - Select **"Web App, Automated App or Bot"**
   
2. **Callback URI / Redirect URL:**
   
   For local development:
   ```
   http://localhost:4200/integrations/social/x
   ```
   
   For production:
   ```
   https://yourdomain.com/integrations/social/x
   ```
   
   **Important:**
   - Match protocol exactly (http vs https)
   - No trailing slashes
   - Port number must match if using non-standard port

3. **Website URL:**
   - Your app's homepage
   - Can be same as callback URL
   - For local dev: `http://localhost:4200`

4. Click **"Save"** button

### Step 7: Retrieve Keys Later (If Needed)

If you need to find or regenerate your keys:

1. Go to **Developer Portal**: https://developer.x.com/
2. Navigate to **"Projects & Apps"** dropdown
3. Select your app
4. Go to **"Keys and tokens"** tab
5. Options available:
   - View existing keys (hidden, can't view original)
   - **"Regenerate"** next to API Key and Secret
   - ⚠️ Regenerating will immediately invalidate old keys

### Step 8: Understand Access Levels

**Free Tier Includes:**
- ✅ Post tweets (max 1,667 tweets per month on v2)
- ✅ OAuth 1.0a user authentication
- ✅ Read/Write permissions
- ✅ Basic timeline access
- ❌ Advanced features (longer posts require Premium)
- ❌ Advanced analytics
- ❌ Full archive search

**Paid Tiers:**
- **Basic**: $100/month - 3,000 tweets/month, extended features
- **Pro**: $5,000/month - 10,000 tweets/month, full access

**For most use cases, Free tier is sufficient for testing and small-scale use.**

---

## Configuration

### Update Your .env File

1. Open your Postiz `.env` file:
   ```bash
   nano /root/bot/postiz-app/.env
   ```

2. Add your credentials (replace with your actual values):

   ```bash
   # Instagram Credentials
   INSTAGRAM_APP_ID="1234567890123456"
   INSTAGRAM_APP_SECRET="abcdef1234567890abcdef1234567890"
   
   # Facebook Credentials (for Instagram Business integration)
   FACEBOOK_APP_ID="1234567890123456"
   FACEBOOK_APP_SECRET="abcdef1234567890abcdef1234567890"
   
   # X (Twitter) Credentials
   X_API_KEY="your_25_character_consumer_key"
   X_API_SECRET="your_50_character_consumer_secret"
   ```

3. Save the file (Ctrl+O, Enter, Ctrl+X in nano)

### Verify Configuration

Check that credentials are properly set:

```bash
grep -E "^(INSTAGRAM_APP_ID|FACEBOOK_APP_ID|X_API_KEY)=" /root/bot/postiz-app/.env
```

### Restart Postiz Services

After updating credentials, restart all services:

```bash
# Stop all running services
pkill -f "node"

# Start backend service
pnpm run start:prod:backend > /tmp/postiz-backend-prod.log 2>&1 &

# Start frontend service
pnpm run start:prod:frontend > /tmp/postiz-frontend-prod.log 2>&1 &

# Start workers service
pnpm run start:prod:workers > /tmp/postiz-workers-prod.log 2>&1 &

# Start cron service
pnpm run start:prod:cron > /tmp/postiz-cron-prod.log 2>&1 &
```

### Verify Services Are Running

```bash
# Check if all services started
ps aux | grep node | grep -v grep

# Check backend logs
tail -f /tmp/postiz-backend-prod.log

# Check frontend logs
tail -f /tmp/postiz-frontend-prod.log
```

### Test Connection

1. Open Postiz in your browser: **http://localhost:4200**
2. Log in or create an account if needed
3. Navigate to **Channels** or **Integrations** section
4. Click **"Connect Instagram"** or **"Connect X"**
5. You'll be redirected to the platform's OAuth authorization page
6. Grant the requested permissions
7. You'll be redirected back to Postiz
8. Your account should now appear in the connected channels list

---

## OAuth Flow Explained

### Instagram OAuth Flow

```
┌─────────────┐                                    ┌──────────────┐
│   User      │                                    │   Instagram  │
│  (Browser)  │                                    │   (Meta)     │
└──────┬──────┘                                    └──────┬───────┘
       │                                                  │
       │ 1. Click "Connect Instagram"                    │
       │──────────────────────────────────────────────▶  │
       │                                                  │
       │ 2. GET /integrations/social/instagram           │
       │    Backend generates OAuth URL with:            │
       │    - client_id (INSTAGRAM_APP_ID)               │
       │    - redirect_uri                               │
       │    - scopes                                     │
       │◀─────────────────────────────────────────────   │
       │                                                  │
       │ 3. Redirect to Instagram OAuth page             │
       │─────────────────────────────────────────────────▶
       │                                                  │
       │ 4. User logs in and grants permissions          │
       │─────────────────────────────────────────────────▶
       │                                                  │
       │ 5. Instagram redirects back with code           │
       │◀─────────────────────────────────────────────────
       │    http://localhost:4200/integrations/          │
       │    social/instagram?code=ABC123&state=XYZ       │
       │                                                  │
       │ 6. POST /integrations/social/instagram/connect  │
       │    Backend exchanges code for access token:     │
       │    - Uses INSTAGRAM_APP_ID                      │
       │    - Uses INSTAGRAM_APP_SECRET                  │
       │    - Sends authorization code                   │
       │──────────────────────────────────────────────▶  │
       │                                                  │
       │                                           ┌──────▼───────┐
       │                                           │ Backend API  │
       │                                           │  - Gets token│
       │                                           │  - Gets user │
       │                                           │    info      │
       │                                           │  - Encrypts  │
       │                                           │  - Stores in │
       │                                           │    PostgreSQL│
       │                                           └──────┬───────┘
       │                                                  │
       │ 7. Account connected & displayed in dashboard   │
       │◀─────────────────────────────────────────────   │
       │                                                  │
       │ 8. User can now schedule Instagram posts        │
```

### X (Twitter) OAuth 1.0a Flow

```
┌─────────────┐                                    ┌──────────────┐
│   User      │                                    │      X       │
│  (Browser)  │                                    │  (Twitter)   │
└──────┬──────┘                                    └──────┬───────┘
       │                                                  │
       │ 1. Click "Connect X"                            │
       │──────────────────────────────────────────────▶  │
       │                                                  │
       │ 2. GET /integrations/social/x                   │
       │    Backend calls X API with:                    │
       │    - X_API_KEY (appKey)                         │
       │    - X_API_SECRET (appSecret)                   │
       │    to obtain request token                      │
       │──────────────────────────────────────────────▶  │
       │                                            ┌─────▼──────┐
       │                                            │  X API     │
       │                                            │  Returns   │
       │                                            │  request   │
       │                                            │  token &   │
       │                                            │  secret    │
       │                                            └─────┬──────┘
       │                                                  │
       │ 3. OAuth URL with request token                 │
       │◀─────────────────────────────────────────────   │
       │                                                  │
       │ 4. Redirect to X authorization page             │
       │─────────────────────────────────────────────────▶
       │                                                  │
       │ 5. User logs in and authorizes app              │
       │─────────────────────────────────────────────────▶
       │                                                  │
       │ 6. X redirects with oauth_token & verifier      │
       │◀─────────────────────────────────────────────────
       │    http://localhost:4200/integrations/          │
       │    social/x?oauth_token=123&oauth_verifier=456  │
       │                                                  │
       │ 7. POST /integrations/social/x/connect          │
       │    Backend exchanges tokens for access token:   │
       │    - Uses X_API_KEY                             │
       │    - Uses X_API_SECRET                          │
       │    - Uses request token + verifier              │
       │──────────────────────────────────────────────▶  │
       │                                                  │
       │                                           ┌──────▼───────┐
       │                                           │ Backend API  │
       │                                           │  - Exchange  │
       │                                           │    for access│
       │                                           │    token     │
       │                                           │  - Get user  │
       │                                           │    profile   │
       │                                           │  - Encrypt & │
       │                                           │    store     │
       │                                           └──────┬───────┘
       │                                                  │
       │ 8. Account connected & displayed                │
       │◀─────────────────────────────────────────────   │
       │                                                  │
       │ 9. User can now schedule tweets                 │
```

### Key Code Components

**IntegrationsController**
- Location: `apps/backend/src/api/routes/integrations.controller.ts`
- Methods:
  - `getIntegrationUrl()` - Generates OAuth URL for social platforms
  - `connectSocialMedia()` - Handles OAuth callback, exchanges code for tokens
  - `functionIntegration()` - Handles token refresh and function calls

**InstagramProvider / InstagramStandaloneProvider**
- Location: `libraries/nestjs-libraries/src/integrations/social/`
- Methods:
  - `generateAuthUrl()` - Creates Instagram OAuth URL
  - `authenticate()` - Exchanges authorization code for access token
  - `refreshToken()` - Refreshes expired access tokens
  - `post()` - Publishes content to Instagram

**XProvider**
- Location: `libraries/nestjs-libraries/src/integrations/social/x.provider.ts`
- Methods:
  - `generateAuthUrl()` - Generates OAuth 1.0a request token and URL
  - `authenticate()` - Completes OAuth 1.0a three-legged flow
  - `post()` - Publishes tweets to X platform

### Database Storage

**Integration Table Schema:**
```
Table: Integration
├── id (UUID)                          - Unique integration ID
├── organizationId (UUID)              - User's organization
├── internalId (String)                - Platform user ID (Instagram/X)
├── name (String)                      - Display name
├── picture (String)                   - Avatar URL
├── type (String)                      - Always "social"
├── providerIdentifier (String)        - "instagram", "x", etc.
├── token (String)                     - Encrypted access token
├── refreshToken (String)              - Encrypted refresh token
├── tokenExpiration (DateTime)         - Token expiry date
├── disabled (Boolean)                 - Channel active status
├── refreshNeeded (Boolean)            - Needs re-authentication
└── profile (JSON)                     - Additional platform data
```

**Token Encryption:**
- Uses `AuthService.fixedEncryption()` method
- Tokens stored encrypted in PostgreSQL
- Automatically decrypted when needed for API calls
- Never exposed in API responses

---

## Troubleshooting

### Common Issues and Solutions

#### Instagram: "Invalid OAuth Redirect URI"

**Symptoms:**
- Error during authorization
- Redirect fails after granting permissions

**Solutions:**
- ✅ Check redirect URI exactly matches in Facebook app settings
- ✅ Remove any trailing slashes from URIs
- ✅ Ensure protocol matches (http vs https)
- ✅ Port number must match if specified
- ✅ Verify the URI is added to "Valid OAuth Redirect URIs" list

**Example correct URIs:**
```
http://localhost:4200/integrations/social/instagram
http://localhost:4200/integrations/social/instagram-standalone
```

#### X: "Invalid API Key" or "Could not authenticate you"

**Symptoms:**
- Cannot generate OAuth URL
- Authentication fails immediately

**Solutions:**
- ✅ Ensure no extra spaces when copying keys from X Developer Portal
- ✅ Check if keys were regenerated (old keys become invalid)
- ✅ Verify app has "Read and write" permissions enabled
- ✅ Confirm OAuth 1.0a is enabled in app settings
- ✅ Check that callback URL is correctly configured

**Verify your credentials:**
```bash
# Check if credentials are set
grep X_API_KEY /root/bot/postiz-app/.env
grep X_API_SECRET /root/bot/postiz-app/.env
```

#### Instagram: "Insufficient Permissions" or "Permission Denied"

**Symptoms:**
- Can't post content
- Limited functionality
- Error when trying to publish

**Solutions:**
- ✅ App must be in "Live" mode (not Development mode)
- ✅ Instagram Business or Creator account required (not personal)
- ✅ Submit app for review and get permissions approved
- ✅ Ensure all required scopes are requested
- ✅ Check that Instagram account is properly linked to Facebook Page

**Development workaround:**
- Add your Instagram account as a "Test User" in app settings
- This allows testing without app review approval

#### X: "Rate Limit Exceeded"

**Symptoms:**
- Error when posting multiple tweets
- API calls failing with 429 error

**Solutions:**
- ✅ Free tier: 1,667 tweets per month limit
- ✅ Wait for rate limit reset (monthly)
- ✅ Consider upgrading to Basic ($100/mo) or Pro tier
- ✅ Reduce posting frequency
- ✅ Check rate limit status in X Developer Portal

**Check current usage:**
- Go to X Developer Portal → Your App → Usage

#### General: "Cannot Connect to Postiz Backend"

**Symptoms:**
- Frontend can't reach backend
- OAuth redirect fails
- 502/503 errors

**Solutions:**
- ✅ Verify all services are running: `ps aux | grep node`
- ✅ Check backend logs: `tail -f /tmp/postiz-backend-prod.log`
- ✅ Ensure `FRONTEND_URL` and `BACKEND_INTERNAL_URL` are correctly set
- ✅ Verify ports 3000 and 4200 are accessible
- ✅ Restart services if needed

#### OAuth Callback: "State Mismatch" or "Invalid State"

**Symptoms:**
- Error after being redirected back from social platform
- OAuth flow fails at final step

**Solutions:**
- ✅ Check Redis is running: `redis-cli ping` (should return "PONG")
- ✅ Verify `REDIS_URL` is correct in `.env`
- ✅ OAuth state tokens expire after 5 minutes - try again
- ✅ Clear browser cookies and retry
- ✅ Check system time is correct (OAuth is time-sensitive)

### Debugging Steps

1. **Check Service Status:**
   ```bash
   ps aux | grep node | grep -v grep
   ```

2. **View Backend Logs:**
   ```bash
   tail -f /tmp/postiz-backend-prod.log
   ```

3. **View Frontend Logs:**
   ```bash
   tail -f /tmp/postiz-frontend-prod.log
   ```

4. **Test Redis Connection:**
   ```bash
   redis-cli ping
   ```

5. **Verify Environment Variables:**
   ```bash
   grep -E "^(INSTAGRAM|FACEBOOK|X_API)" /root/bot/postiz-app/.env
   ```

6. **Check Database Connection:**
   ```bash
   psql $DATABASE_URL -c "SELECT COUNT(*) FROM \"Integration\";"
   ```

7. **Test Backend Health:**
   ```bash
   curl http://localhost:3000/health
   ```

### Enable Debug Logging

For more detailed logs, you can set:

```bash
# Add to .env file
LOG_LEVEL="debug"
NODE_ENV="development"
```

Then restart services to see more detailed output.

---

## Official Documentation Links

### Instagram / Meta / Facebook

**Developer Portals:**
- Meta Developer Portal: https://developers.facebook.com/
- App Dashboard: https://developers.facebook.com/apps/

**Documentation:**
- Instagram Platform Overview: https://developers.facebook.com/docs/instagram-platform
- Instagram Graph API: https://developers.facebook.com/docs/instagram-api
- Instagram Basic Display API: https://developers.facebook.com/docs/instagram-basic-display-api
- Instagram Content Publishing: https://developers.facebook.com/docs/instagram-platform/content-publishing
- Instagram API with Instagram Login: https://developers.facebook.com/docs/instagram-platform/instagram-api-with-instagram-login

**App Review:**
- App Review Process: https://developers.facebook.com/docs/instagram-platform/app-review
- Permissions Reference: https://developers.facebook.com/docs/permissions/reference

**Support:**
- Developer Community: https://www.facebook.com/groups/fbdevelopers/
- Bug Reporting: https://developers.facebook.com/support/bugs/
- Platform Status: https://metastatus.com/

### X (Twitter)

**Developer Portals:**
- X Developer Portal: https://developer.x.com/
- App Dashboard: https://developer.x.com/en/portal/dashboard

**Documentation:**
- Getting Started Guide: https://developer.x.com/en/docs/x-api/getting-started
- OAuth 1.0a Documentation: https://developer.x.com/en/docs/authentication/oauth-1-0a
- API Key and Secret: https://developer.x.com/en/docs/authentication/oauth-1-0a/api-key-and-secret
- Obtaining User Access Tokens: https://developer.x.com/en/docs/authentication/oauth-1-0a/obtaining-user-access-tokens
- API Reference: https://developer.x.com/en/docs/x-api

**Rate Limits:**
- Rate Limit Information: https://developer.x.com/en/docs/rate-limits
- Access Levels: https://developer.x.com/en/docs/x-api/getting-started/about-x-api

**Tools:**
- Postman Collection: https://developer.x.com/en/docs/tutorials/postman-getting-started
- Code Examples: https://github.com/xdevplatform

**Support:**
- Developer Forums: https://twittercommunity.com/
- Platform Status: https://api.twitterstat.us/

### Postiz

**Project Resources:**
- Postiz Website: https://postiz.com
- Documentation: https://docs.postiz.com
- Quick Start Guide: https://docs.postiz.com/quickstart
- Public API Docs: https://docs.postiz.com/public-api
- GitHub Repository: https://github.com/gitroomhq/postiz-app
- Discord Community: https://discord.postiz.com
- YouTube Tutorials: https://youtube.com/@postizofficial

---

## Quick Reference

### Redirect URIs for localhost:4200

```
Instagram Standalone:    http://localhost:4200/integrations/social/instagram-standalone
Instagram Business:      http://localhost:4200/integrations/social/instagram
X (Twitter):            http://localhost:4200/integrations/social/x
Facebook:               http://localhost:4200/integrations/social/facebook
```

### Environment Variables Summary

```bash
# Required for Instagram Standalone
INSTAGRAM_APP_ID=""
INSTAGRAM_APP_SECRET=""

# Required for Instagram via Facebook
FACEBOOK_APP_ID=""
FACEBOOK_APP_SECRET=""

# Required for X (Twitter)
X_API_KEY=""
X_API_SECRET=""

# Base URLs (already configured)
FRONTEND_URL="http://localhost:4200"
NEXT_PUBLIC_BACKEND_URL="http://localhost:3000"
BACKEND_INTERNAL_URL="http://localhost:3000"
```

### Service Management Commands

```bash
# Stop all services
pkill -f "node"

# Start all services
pnpm run start:prod:backend > /tmp/postiz-backend-prod.log 2>&1 &
pnpm run start:prod:frontend > /tmp/postiz-frontend-prod.log 2>&1 &
pnpm run start:prod:workers > /tmp/postiz-workers-prod.log 2>&1 &
pnpm run start:prod:cron > /tmp/postiz-cron-prod.log 2>&1 &

# Check service status
ps aux | grep node | grep -v grep

# View logs
tail -f /tmp/postiz-backend-prod.log
tail -f /tmp/postiz-frontend-prod.log
```

---

## Checklist

### Instagram Setup Checklist
- [ ] Meta Developer account created
- [ ] App created in Developer Portal
- [ ] Instagram product added to app
- [ ] OAuth redirect URIs configured
- [ ] App ID copied to `.env` file
- [ ] App Secret copied to `.env` file
- [ ] Instagram Business/Creator account ready
- [ ] Required permissions requested (for production)
- [ ] App submitted for review (for production)

### X (Twitter) Setup Checklist
- [ ] X Developer account created and approved
- [ ] Project created (for v2 API access)
- [ ] App created within project
- [ ] API Key (Consumer Key) saved
- [ ] API Secret (Consumer Secret) saved
- [ ] OAuth 1.0a enabled with "Read and write" permissions
- [ ] Callback URL configured correctly
- [ ] API Key added to `.env` file
- [ ] API Secret added to `.env` file

### Postiz Configuration Checklist
- [ ] `.env` file updated with all credentials
- [ ] All services stopped
- [ ] All services restarted
- [ ] Backend accessible at http://localhost:3000
- [ ] Frontend accessible at http://localhost:4200
- [ ] Connection test successful for Instagram
- [ ] Connection test successful for X
- [ ] Accounts visible in dashboard
- [ ] Test post successful

---

## Need Help?

If you encounter issues not covered in this guide:

1. **Check Logs First:**
   - Backend: `/tmp/postiz-backend-prod.log`
   - Frontend: `/tmp/postiz-frontend-prod.log`

2. **Community Support:**
   - Discord: https://discord.postiz.com
   - GitHub Issues: https://github.com/gitroomhq/postiz-app/issues

3. **Official Documentation:**
   - Postiz Docs: https://docs.postiz.com
   - Meta Developers: https://developers.facebook.com/support/
   - X Developers: https://twittercommunity.com/

4. **Search Existing Issues:**
   - Many common issues are already documented
   - Check closed issues on GitHub for solutions

---

**Document Version:** 1.0  
**Last Updated:** October 31, 2025  
**Postiz Version:** 2.x  
**Created for:** Postiz Self-Hosted Installation

---

*This guide is based on official documentation from Meta Platforms and X Corp, along with the Postiz open-source codebase. Keep credentials secure and never commit them to version control.*
