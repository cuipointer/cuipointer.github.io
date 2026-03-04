#!/bin/bash

echo "╔════════════════════════════════════════╗"
echo "║   Hexo Local Preview                  ║"
echo "╚════════════════════════════════════════╝"
echo ""

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

cd "$(dirname "$0")/.."

echo "📦 Cleaning old build..."
npm run clean

echo ""
echo "🏗️  Building..."
npm run build
BUILD_COUNT=$(find public -type f 2>/dev/null | wc -l)
echo "✅ Generated $BUILD_COUNT files"

echo ""
echo "🚀 Starting local server..."
echo ""
echo "────────────────────────────────────"
echo "📍 Preview: http://localhost:4000/"
echo "────────────────────────────────────"
echo ""
echo "⏹️  Press Ctrl+C to stop"
echo ""

npm run server
