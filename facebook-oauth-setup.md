# Facebook OAuth Redirect URIs Setup

## Current Configuration
- **App ID**: 4103660183289326
- **App Name**: n8n
- **Your Server**: http://134.199.234.106:5000

## Required OAuth Redirect URIs

Add these URLs to your Facebook App's "Valid OAuth Redirect URIs" field:

```
http://134.199.234.106:5000/integrations/social/facebook
http://134.199.234.106:5000/integrations/social/instagram
```

## Where to Add Them

1. Go to: https://developers.facebook.com/apps/4103660183289326/business-login/settings/
2. Scroll to the TOP of the page
3. Look for "Client OAuth settings" section
4. Find the "Valid OAuth Redirect URIs" input field
5. Paste the URLs above (one per line or use the "Add another redirect URI" button)
6. Click "Save changes" at the bottom
7. Test using the "Redirect URI Validator" section below

## Verification

After saving, you can verify by:
1. Using the "Redirect URI Validator" on the same page
2. Paste each URL and click "Check URI"
3. Should see: ✅ "This is a valid redirect URI"

## Next Steps After Configuration

1. No need to restart Postiz - OAuth config is on Facebook's side
2. Go to: http://134.199.234.106:5000
3. Login to Postiz
4. Click "Instagram (Facebook Business)" (NOT "Instagram Standalone")
5. Follow the OAuth flow to connect your accounts

## Troubleshooting

If you still see errors:
- Make sure "Client OAuth login" is enabled (toggle to Yes)
- Make sure "Web OAuth login" is enabled (toggle to Yes)
- "Enforce HTTPS" can be Yes or No (we're using HTTP for now)
- App Mode can be "Development" (add test users) or switch to "Live"
- Clear browser cache and try again
