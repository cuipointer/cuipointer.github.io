#!/usr/bin/env bash
# Hexo + GitHub Pages 博客一键初始化脚本
# 适用于从零开始搭建个人博客

set -euo pipefail

echo "════════════════════════════════════════════════════════════"
echo "  Hexo + GitHub Pages 博客一键搭建脚本"
echo "════════════════════════════════════════════════════════════"
echo ""

# 配置变量（根据需要修改）
GITHUB_USER="cuipointer"
REPO_NAME="cuihan"
GITHUB_REPO="git@github.com:${GITHUB_USER}/${REPO_NAME}.git"
BLOG_TITLE="Cuihan's Blog"
BLOG_AUTHOR="Cuihan"
THEME_NAME="cactus"

# 读取项目目录
read -p "📁 请输入博客项目目录路径 [默认: ~/my-blog]: " PROJECT_DIR
PROJECT_DIR="${PROJECT_DIR:-$HOME/my-blog}"

echo ""
echo "📋 配置信息："
echo "  - 项目目录: $PROJECT_DIR"
echo "  - GitHub 仓库: $GITHUB_REPO"
echo "  - 博客标题: $BLOG_TITLE"
echo "  - 主题: $THEME_NAME"
echo ""
read -p "确认开始安装？(y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "已取消安装"
  exit 0
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "步骤 1/7: 检查并安装 Node.js 环境"
echo "════════════════════════════════════════════════════════════"

# 安装 NVM 和 Node.js
export NVM_DIR="$HOME/.nvm"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  echo "正在安装 NVM..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

. "$NVM_DIR/nvm.sh"

if ! command -v node &> /dev/null; then
  echo "正在安装 Node.js LTS..."
  nvm install --lts
fi

nvm use --lts
echo "✅ Node.js 版本: $(node -v)"
echo "✅ NPM 版本: $(npm -v)"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "步骤 2/7: 创建项目目录并初始化 Hexo"
echo "════════════════════════════════════════════════════════════"

mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo "正在初始化 Hexo..."
npx hexo init .
npm install

echo "安装 Git 部署插件..."
npm install hexo-deployer-git --save

echo "✅ Hexo 初始化完成"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "步骤 3/7: 安装并配置 Cactus 主题"
echo "════════════════════════════════════════════════════════════"

echo "正在克隆 Cactus 主题..."
git clone https://github.com/probberechts/hexo-theme-cactus.git themes/cactus
rm -rf themes/cactus/.git

echo "复制主题配置文件..."
cp themes/cactus/_config.yml _config.cactus.yml

echo "✅ Cactus 主题安装完成"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "步骤 4/7: 配置站点信息"
echo "════════════════════════════════════════════════════════════"

# 修改站点配置
cat > _config.yml << EOF
# Hexo Configuration
## Docs: https://hexo.io/docs/configuration.html
## Source: https://github.com/hexojs/hexo/

# Site
title: $BLOG_TITLE
subtitle: '技术分享与个人思考'
description: '记录学习与生活的点点滴滴'
keywords:
  - 技术博客
  - Hexo
  - GitHub Pages
author: $BLOG_AUTHOR
language: zh-CN
timezone: 'Asia/Shanghai'

# URL
url: https://${GITHUB_USER}.github.io/${REPO_NAME}
root: /${REPO_NAME}/
permalink: :year/:month/:day/:title/
permalink_defaults:
pretty_urls:
  trailing_index: true
  trailing_html: true

# Directory
source_dir: source
public_dir: public
tag_dir: tags
archive_dir: archives
category_dir: categories
code_dir: downloads/code
i18n_dir: :lang
skip_render:

# Writing
new_post_name: :title.md
default_layout: post
titlecase: false
external_link:
  enable: true
  field: site
  exclude: ''
filename_case: 0
render_drafts: false
post_asset_folder: false
relative_link: false
future: true
syntax_highlighter: highlight.js
highlight:
  line_number: true
  auto_detect: false
  tab_replace: ''
  wrap: true
  hljs: false
prismjs:
  preprocess: true
  line_number: true
  tab_replace: ''

# Home page setting
index_generator:
  path: ''
  per_page: 10
  order_by: -date

# Category & Tag
default_category: uncategorized
category_map:
tag_map:

# Metadata elements
meta_generator: true

# Date / Time format
date_format: YYYY-MM-DD
time_format: HH:mm:ss
updated_option: 'mtime'

# Pagination
per_page: 10
pagination_dir: page

# Include / Exclude file(s)
include:
exclude:
ignore:

# Extensions
theme: cactus

# Deployment
deploy:
  type: git
  repo: $GITHUB_REPO
  branch: gh-pages
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
EOF

echo "✅ 站点配置完成"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "步骤 5/7: 创建示例文章"
echo "════════════════════════════════════════════════════════════"

# 创建 About 页面
npx hexo new page about
cat > source/about/index.md << 'EOF'
---
title: 关于我
date: $(date +"%Y-%m-%d %H:%M:%S")
type: about
comments: false
---

## 👋 你好，我是 Cuihan

欢迎来到我的个人博客！

### 🎓 关于我

- 💻 一名热爱技术的开发者
- 📝 喜欢记录学习过程和技术心得
- 🌱 持续学习，不断成长

### 📮 联系方式

- **GitHub**：[@cuipointer](https://github.com/cuipointer)

感谢你的访问！

---

*Keep Learning, Keep Coding!* 🚀
EOF

echo "✅ 示例文章创建完成"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "步骤 6/7: 创建快捷脚本"
echo "════════════════════════════════════════════════════════════"

# 创建部署脚本
cat > deploy.sh << 'EOFSCRIPT'
#!/usr/bin/env bash
set -euo pipefail

echo "🚀 开始部署博客到 GitHub Pages..."

export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  . "$NVM_DIR/nvm.sh"
  nvm use --lts >/dev/null 2>&1
fi

cd "$(dirname "$0")"

echo "📦 清理缓存..."
npm run clean

echo "🔨 生成静态文件..."
npm run build

echo "📤 部署到 GitHub Pages..."
npm run deploy

echo ""
echo "✅ 部署完成！"
echo "🌐 访问地址：https://cuipointer.github.io/cuihan"
EOFSCRIPT

chmod +x deploy.sh

# 创建新建文章脚本
cat > new_post.sh << 'EOFSCRIPT'
#!/usr/bin/env bash
set -euo pipefail

export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  . "$NVM_DIR/nvm.sh"
  nvm use --lts >/dev/null 2>&1
fi

cd "$(dirname "$0")"

if [[ $# -eq 0 ]]; then
  read -p "📝 请输入文章标题: " title
else
  title="$1"
fi

npx hexo new "$title"
echo "✅ 文章已创建：source/_posts/$title.md"
EOFSCRIPT

chmod +x new_post.sh

echo "✅ 快捷脚本创建完成"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "步骤 7/7: 初始化 Git 仓库"
echo "════════════════════════════════════════════════════════════"

# 创建 .gitignore
cat > .gitignore << EOF
node_modules/
db.json
.deploy_*/
public/
.DS_Store
Thumbs.db
*.log
.idea/
.vscode/
*.swp
*.swo
*~
EOF

git init
git add .
git commit -m "Initial commit: Hexo blog with cactus theme"
git branch -M main
git remote add origin "$GITHUB_REPO"

echo "✅ Git 仓库初始化完成"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  🎉 博客搭建完成！"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📂 项目位置: $PROJECT_DIR"
echo ""
echo "🔑 下一步操作："
echo ""
echo "1. 配置 GitHub SSH 密钥（如果还没有配置）："
echo "   ssh-keygen -t rsa -C \"your@email.com\""
echo "   cat ~/.ssh/id_rsa.pub"
echo "   # 将公钥添加到 GitHub Settings -> SSH Keys"
echo ""
echo "2. 在 GitHub 创建仓库: $REPO_NAME"
echo ""
echo "3. 本地预览："
echo "   cd $PROJECT_DIR"
echo "   npm run server"
echo "   # 访问 http://localhost:4000/${REPO_NAME}"
echo ""
echo "4. 推送源码到 GitHub："
echo "   git push -u origin main"
echo ""
echo "5. 部署到 GitHub Pages："
echo "   ./deploy.sh"
echo ""
echo "6. 在 GitHub 仓库设置中："
echo "   Settings -> Pages -> Source 选择 'gh-pages' 分支"
echo ""
echo "7. 新建文章："
echo "   ./new_post.sh \"文章标题\""
echo ""
echo "════════════════════════════════════════════════════════════"
echo "📚 更多帮助请查看项目中的 README.md"
echo "════════════════════════════════════════════════════════════"
