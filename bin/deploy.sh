#!/bin/bash
set -e

echo "╔════════════════════════════════════════╗"
echo "║   Hexo Blog Deployment Script         ║"
echo "╚════════════════════════════════════════╝"

# Load nvm if available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

cd "$(dirname "$0")/.."

echo "🧹 Step 1: Cleaning..."
npm run clean

echo "🔨 Step 2: Building..."
npm run build
BUILD_COUNT=$(find public -type f 2>/dev/null | wc -l)
echo "   ✅ Generated $BUILD_COUNT files"

echo "🚀 Step 3: Deploying to GitHub..."
npm run deploy

echo ""
echo "✅ Deployment complete!"
DOMAIN=$(grep '^url:' _config.yml | awk '{print $2}' | sed 's|https://||;s|/||')
echo "🌐 Visit: https://$DOMAIN"
echo ""
echo "⏳ GitHub may take 1-3 minutes to update the site."
