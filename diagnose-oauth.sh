#!/bin/bash

# Postiz OAuth Diagnostic Script
# This helps identify why Instagram/Facebook integration isn't working

echo "=================================================="
echo "🔍 Postiz OAuth Integration Diagnostics"
echo "=================================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check environment variables
echo -e "${BLUE}1. Checking Environment Variables${NC}"
echo "---"

if [ -f ".env.production" ]; then
    FACEBOOK_APP_ID=$(grep "^FACEBOOK_APP_ID=" .env.production | cut -d'=' -f2 | tr -d '"')
    FACEBOOK_APP_SECRET=$(grep "^FACEBOOK_APP_SECRET=" .env.production | cut -d'=' -f2 | tr -d '"')
    FRONTEND_URL=$(grep "^FRONTEND_URL=" .env.production | cut -d'=' -f2 | tr -d '"')
    
    if [ ! -z "$FACEBOOK_APP_ID" ]; then
        echo -e "${GREEN}✓${NC} FACEBOOK_APP_ID: $FACEBOOK_APP_ID"
    else
        echo -e "${RED}✗${NC} FACEBOOK_APP_ID: Not set"
    fi
    
    if [ ! -z "$FACEBOOK_APP_SECRET" ]; then
        echo -e "${GREEN}✓${NC} FACEBOOK_APP_SECRET: ${FACEBOOK_APP_SECRET:0:10}..."
    else
        echo -e "${RED}✗${NC} FACEBOOK_APP_SECRET: Not set"
    fi
    
    if [ ! -z "$FRONTEND_URL" ]; then
        echo -e "${GREEN}✓${NC} FRONTEND_URL: $FRONTEND_URL"
    else
        echo -e "${RED}✗${NC} FRONTEND_URL: Not set"
    fi
else
    echo -e "${RED}✗${NC} .env.production file not found"
fi

echo ""
echo -e "${BLUE}2. Checking Service Status${NC}"
echo "---"

# Check backend
if curl -s http://localhost:3000/ > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Backend (port 3000): Running"
else
    echo -e "${RED}✗${NC} Backend (port 3000): Not responding"
fi

# Check frontend
if curl -s http://localhost:4200/ > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Frontend (port 4200): Running"
else
    echo -e "${RED}✗${NC} Frontend (port 4200): Not responding"
fi

# Check nginx
if curl -s http://localhost:5000/ > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Nginx (port 5000): Running"
else
    echo -e "${RED}✗${NC} Nginx (port 5000): Not responding"
fi

echo ""
echo -e "${BLUE}3. Testing Facebook API Access${NC}"
echo "---"

if [ ! -z "$FACEBOOK_APP_ID" ] && [ ! -z "$FACEBOOK_APP_SECRET" ]; then
    # Test app access token
    TOKEN_RESPONSE=$(curl -s "https://graph.facebook.com/oauth/access_token?client_id=$FACEBOOK_APP_ID&client_secret=$FACEBOOK_APP_SECRET&grant_type=client_credentials")
    
    if echo "$TOKEN_RESPONSE" | grep -q "access_token"; then
        echo -e "${GREEN}✓${NC} Facebook API: Credentials valid"
        ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
        
        # Get app info
        APP_INFO=$(curl -s "https://graph.facebook.com/v20.0/$FACEBOOK_APP_ID?access_token=$ACCESS_TOKEN")
        APP_NAME=$(echo "$APP_INFO" | grep -o '"name":"[^"]*' | cut -d'"' -f4)
        
        if [ ! -z "$APP_NAME" ]; then
            echo -e "${GREEN}✓${NC} App Name: $APP_NAME"
        fi
    else
        echo -e "${RED}✗${NC} Facebook API: Invalid credentials"
        echo "   Response: $TOKEN_RESPONSE"
    fi
else
    echo -e "${YELLOW}⚠${NC}  Cannot test - credentials not configured"
fi

echo ""
echo -e "${BLUE}4. Required OAuth Redirect URIs${NC}"
echo "---"
echo "Add these to your Facebook App:"
echo "  → ${FRONTEND_URL:-http://localhost:5000}/integrations/social/facebook"
echo "  → ${FRONTEND_URL:-http://localhost:5000}/integrations/social/instagram"
echo "  → ${FRONTEND_URL:-http://localhost:5000}/integrations/social/instagram-standalone"

echo ""
echo -e "${BLUE}5. Facebook App Configuration Checklist${NC}"
echo "---"
echo "Go to: https://developers.facebook.com/apps/$FACEBOOK_APP_ID"
echo ""
echo "[ ] 1. Settings → Basic → Add Platform → Website"
echo "       Site URL: ${FRONTEND_URL:-http://localhost:5000}"
echo ""
echo "[ ] 2. Add Product → Instagram → Instagram Graph API"
echo ""
echo "[ ] 3. Add Product → Facebook Login → Settings"
echo "       Valid OAuth Redirect URIs: (add all 3 URLs from above)"
echo ""
echo "[ ] 4. Roles → Add yourself as Admin/Developer"
echo ""
echo "[ ] 5. App Review → Make app Live OR use as test user"

echo ""
echo -e "${BLUE}6. Testing OAuth URL Generation${NC}"
echo "---"

# Generate a test OAuth URL
if [ ! -z "$FACEBOOK_APP_ID" ]; then
    REDIRECT_URI="${FRONTEND_URL:-http://localhost:5000}/integrations/social/instagram"
    SCOPES="instagram_business_basic,instagram_business_content_publish,instagram_business_manage_comments,instagram_business_manage_insights,pages_show_list,pages_read_engagement,pages_manage_posts,business_management"
    STATE="test123"
    
    OAUTH_URL="https://www.facebook.com/v20.0/dialog/oauth?client_id=$FACEBOOK_APP_ID&redirect_uri=$(echo $REDIRECT_URI | sed 's/:/%3A/g' | sed 's/\//%2F/g')&state=$STATE&scope=$SCOPES"
    
    echo "Test URL (click to test):"
    echo "$OAUTH_URL"
    echo ""
    echo "If this URL opens Facebook login, your app is configured correctly!"
fi

echo ""
echo "=================================================="
echo -e "${GREEN}Diagnostic Complete${NC}"
echo "=================================================="
echo ""
echo "📝 Next Steps:"
echo "   1. Configure Facebook App with URLs above"
echo "   2. Add Instagram Graph API product"
echo "   3. Test the OAuth URL above in your browser"
echo "   4. Try connecting again in Postiz"
echo ""
