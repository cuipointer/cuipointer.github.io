#!/bin/bash

echo "╔════════════════════════════════════════╗"
echo "║   Environment Check                   ║"
echo "╚════════════════════════════════════════╝"
echo ""

PASS=0
FAIL=0

check_command() {
  if command -v "$1" &> /dev/null; then
    VERSION=$("$1" "$2" 2>&1 | head -1)
    echo "✅ $1: $VERSION"
    ((PASS++))
  else
    echo "❌ $1 not found"
    ((FAIL++))
  fi
}

echo "1️⃣  System Tools"
check_command git "--version"
check_command curl "--version"
echo ""

echo "2️⃣  Node.js Development"
check_command node "-v"
check_command npm "-v"
echo ""

echo "3️⃣  SSH Configuration"
if [ -f ~/.ssh/id_ed25519 ]; then
  echo "✅ Ed25519 key exists"
  ((PASS++))
else
  echo "❌ Ed25519 key not found at ~/.ssh/id_ed25519"
  ((FAIL++))
fi

if [ -f ~/.ssh/config ]; then
  echo "✅ SSH config file exists"
  ((PASS++))
else
  echo "❌ SSH config file not found"
  ((FAIL++))
fi
echo ""

echo "4️⃣  GitHub SSH Connection"
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "✅ SSH connection successful"
  ((PASS++))
else
  echo "⚠️  SSH connection test may have failed (check GitHub key setup)"
  ((FAIL++))
fi
echo ""

echo "5️⃣  Hexo Configuration"
if [ -f "_config.yml" ]; then
  echo "✅ _config.yml exists"
  ((PASS++))
  
  REPO=$(grep "repo:" _config.yml | awk '{print $2}')
  BRANCH=$(grep "branch:" _config.yml | awk '{print $2}')
  URL=$(grep "^url:" _config.yml | awk '{print $2}')
  
  echo "   Deploy repo: $REPO"
  echo "   Deploy branch: $BRANCH"
  echo "   Site URL: $URL"
else
  echo "❌ _config.yml not found"
  ((FAIL++))
fi
echo ""

echo "6️⃣  Project Structure"
[ -d "source/_posts" ] && echo "✅ source/_posts exists" && ((PASS++)) || (echo "❌ source/_posts not found" && ((FAIL++)))
[ -d "themes" ] && echo "✅ themes directory exists" && ((PASS++)) || (echo "❌ themes not found" && ((FAIL++)))
[ -d "node_modules" ] && echo "✅ node_modules installed" && ((PASS++)) || (echo "⚠️  node_modules not found (run: npm install)" && ((FAIL++)))
echo ""

echo "══════════════════════════════════════════"
echo "Summary: ✅ $PASS passed, ❌ $FAIL failed"
echo "══════════════════════════════════════════"

if [ $FAIL -eq 0 ]; then
  echo "🎉 All checks passed! You're ready to go."
  exit 0
else
  echo "⚠️  Please fix the failed checks above."
  exit 1
fi
