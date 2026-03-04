#!/usr/bin/env bash
# 一键部署脚本 - Deploy to GitHub Pages
set -euo pipefail

echo "🚀 开始部署博客到 GitHub Pages..."

# 加载 Node.js 环境
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  . "$NVM_DIR/nvm.sh"
  nvm use --lts >/dev/null 2>&1
fi

# 切换到项目目录
cd "$(dirname "$0")"

# 清理旧文件
echo "📦 清理缓存..."
npm run clean

# 生成静态文件
echo "🔨 生成静态文件..."
npm run build

# 部署到 GitHub Pages
echo "📤 部署到 GitHub Pages..."
npm run deploy

echo ""
echo "✅ 部署完成！"
echo "🌐 访问地址：https://cuipointer.github.io/cuihan"
echo ""
echo "⏳ 注意：GitHub Pages 可能需要几分钟才能更新"
