#!/bin/bash

if [ $# -eq 0 ]; then
  echo "📝 Usage: $0 \"Article Title\""
  echo ""
  echo "Example:"
  echo "  $0 \"My First Blog Post\""
  exit 1
fi

TITLE="$1"
SLUG=$(echo "$TITLE" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

cd "$(dirname "$0")/.."

echo "📝 Creating new post: $TITLE"
npx hexo new "$TITLE"

# Find the created file
FILENAME=$(find source/_posts -name "*${SLUG}*" -o -name "*${TITLE}*" 2>/dev/null | head -1)

if [ -f "$FILENAME" ]; then
  echo "✅ Post created: $FILENAME"
  echo ""
  echo "📖 Next steps:"
  echo "   1. Edit: nano $FILENAME"
  echo "   2. Preview: ./scripts/preview.sh"
  echo "   3. Deploy: ./scripts/deploy.sh"
else
  echo "❌ Failed to create post"
  exit 1
fi
