# Hexo + GitHub Pages 完整部署教程

> **最后更新：** 2026-03-05  
> **适用版本：** Hexo 8.x, Node.js 18+, Ubuntu 20.04+  
> **难度级别：** ⭐⭐ 中级

---

## 目录

1. [环境部署及验证](#第一部分环境部署及验证)
2. [输出第一篇博客及本地渲染](#第二部分输出第一篇博客及本地渲染)
3. [重要注意事项](#第三部分重要注意事项)
4. [原理解析](#第四部分原理解析)
5. [快捷脚本](#第五部分快捷脚本)

---

## 第一部分：环境部署及验证

### 1.1 系统环境要求

```bash
# 检查系统版本
cat /etc/os-release

# 推荐：Ubuntu 18.04+ 或 Debian 10+
```

### 1.2 安装 Git

```bash
# 安装
sudo apt update
sudo apt install git -y

# 验证
git --version
# 预期输出：git version 2.x.x
```

### 1.3 安装 Node.js（使用 nvm）

**为什么用 nvm？**
- 用户级安装，无需 sudo
- 可轻松切换 Node 版本
- 避免 apt 仓库版本过旧

```bash
# 1. 下载并安装 nvm
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# 2. 重新加载 shell 配置
source ~/.bashrc
# 如果用 zsh，执行：source ~/.zshrc

# 3. 安装 Node.js LTS 版本
nvm install --lts

# 4. 设置默认版本（可选）
nvm alias default lts/*

# 5. 验证
node -v     # v20.x.x 或更新
npm -v      # v11.x.x 或更新
which node  # 应显示 /home/username/.nvm/versions/...
```

**验证 Node.js 安装：**
```bash
#!/bin/bash
echo "=== Node.js 和 npm 版本检查 ==="
node --version
npm --version

echo "=== npm 全局包路径 ==="
npm config get prefix

echo "=== 检查 nvm ==="
command -v nvm && echo "✅ nvm 可用" || echo "❌ nvm 不可用"
```

### 1.4 生成并配置 SSH 密钥

```bash
# 1. 生成密钥（使用 ed25519，更安全、更快）
ssh-keygen -t ed25519 -C "your@email.com" -f ~/.ssh/id_ed25519 -N ""

# 2. 查看公钥
cat ~/.ssh/id_ed25519.pub

# 3. 添加到 GitHub
# 访问：https://github.com/settings/keys
# 点击 "New SSH key"
# 粘贴公钥内容

# 4. 配置 SSH 配置文件
cat > ~/.ssh/config <<'EOF'
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  AddKeysToAgent yes
EOF

# 5. 设置权限
chmod 600 ~/.ssh/config
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519

# 6. 测试连接
ssh -T git@github.com
# 预期输出：Hi username! You've successfully authenticated...
```

**验证脚本：**
```bash
#!/bin/bash
echo "=== SSH 密钥检查 ==="
if [ -f ~/.ssh/id_ed25519 ]; then
  echo "✅ Ed25519 密钥存在"
else
  echo "❌ Ed25519 密钥不存在"
fi

echo -e "\n=== GitHub SSH 连接测试 ==="
ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" && echo "✅ SSH 连接成功" || echo "❌ SSH 连接失败"
```

### 1.5 创建 GitHub 仓库

**两个必需的仓库：**

| 仓库名 | 用途 | 创建方式 |
|-------|------|--------|
| `username.github.io` | GitHub Pages 发布仓库 | https://github.com/new |
| `hexo-blog` 或 `blog` | 源代码备份 | https://github.com/new |

```bash
# 创建仓库后，验证
git ls-remote git@github.com:username/username.github.io.git || echo "❌ 仓库不可访问"
```

---

## 第二部分：输出第一篇博客及本地渲染

### 2.1 初始化 Hexo 项目

```bash
# 1. 创建工作目录
mkdir -p ~/Projects
cd ~/Projects

# 2. 初始化 Hexo 项目
npx hexo-cli init blog
cd blog

# 3. 安装依赖
npm install

# 验证
ls -la | head -20
# 应该看到：_config.yml, source/, themes/, package.json 等
```

### 2.2 配置 Hexo（关键步骤）

编辑 `_config.yml`，修改以下部分：

**基本信息：**
```yaml
# Site
title: My Awesome Blog
subtitle: 'A modern blog platform'
description: 'Technology sharing and personal thoughts'
author: Your Name
language: en  # 或 zh-CN
timezone: 'UTC'  # 或 'Asia/Shanghai'
```

**URL 配置（⭐ 重要）：**
```yaml
# URL
url: https://username.github.io/    # 替换 username
root: /                              # 用户页面用 /，项目页面用 /project-name/
permalink: :year/:month/:day/:title/
```

**部署配置（⭐ 最重要）：**
```yaml
# Deployment
deploy:
  type: git
  repo: git@github.com:username/username.github.io.git
  branch: main
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
```

**语言和主题：**
```yaml
theme: landscape           # 默认主题
language: zh-CN           # 中文支持
```

### 2.3 创建第一篇博客文章

```bash
# 方法 A：使用 Hexo 命令
npx hexo new "My First Post"

# 或创建草稿
npx hexo new draft "My Draft Post"
```

编辑生成的文件 `source/_posts/my-first-post.md`：

```markdown
---
title: My First Post
date: 2026-03-05 10:00:00
tags:
  - Hexo
  - Blog
categories:
  - Tutorial
---

这是我的第一篇博客文章。

## 第一个标题

这是内容...

更多内容可以在这里添加。

## 代码示例

\`\`\`python
print("Hello, Hexo!")
\`\`\`
```

### 2.4 本地渲染和预览

```bash
# 1. 清理旧的构建
npm run clean

# 2. 生成静态文件
npm run build

# 输出示例：
# INFO Generated: 25 files in 234 ms

# 3. 启动本地服务器
npm run server

# 输出示例：
# INFO Hexo is running at http://localhost:4000/
# Press Ctrl+C to stop
```

**验证本地预览：**
```bash
# 打开浏览器访问
http://localhost:4000/

# 应该看到：
# - 首页显示博客标题
# - "My First Post" 文章出现在列表中
# - CSS 样式已加载（页面应该漂亮，而不是纯文本）
```

**停止服务器：**
```bash
# 按下 Ctrl+C
```

### 2.5 验证生成的文件

```bash
# 1. 查看生成的静态文件
ls -la public/

# 应该包含：
# index.html, about/, archives/, css/, js/, lib/ 等

# 2. 检查首页内容
cat public/index.html | head -30

# 应该包含：
# <!DOCTYPE html>
# <html>
# 包含你配置的标题等内容
```

---

## 第三部分：重要注意事项

### ⚠️ 注意事项 1：SSH 密钥认证

**问题：** `Permission denied (publickey)`

**检查清单：**
- [ ] 在 GitHub Settings → Keys 添加了公钥
- [ ] 本地密钥文件有正确权限（`chmod 600 ~/.ssh/id_ed25519`）
- [ ] `ssh -T git@github.com` 返回成功消息
- [ ] ~/.ssh/config 已正确配置

**排查：**
```bash
# 测试 SSH
ssh -vvv git@github.com 2>&1 | head -20

# 查看已加载的密钥
ssh-add -l
# 如果为空，执行：
ssh-add ~/.ssh/id_ed25519
```

### ⚠️ 注意事项 2：部署配置错误

**问题：** 推送到了错误的仓库或分支

**检查清单：**
- [ ] `deploy.repo` = `git@github.com:username/username.github.io.git`（不是其他仓库）
- [ ] `deploy.branch` = `main`（用户页面不用 gh-pages）
- [ ] `url` 和 `root` 正确配置

**验证：**
```bash
# 查看部署配置
grep -A 5 'deploy:' _config.yml
```

### ⚠️ 注意事项 3：URL 路径混乱

**常见错误：**
```yaml
# ❌ 错误
url: https://username.github.io/blog/
root: /blog/

# ✅ 正确（用户页面）
url: https://username.github.io/
root: /
```

**症状：** 页面打开但 CSS/JS/图片加载失败（404）

**解决：** 修改后必须执行 `npm run clean && npm run build`

### ⚠️ 注意事项 4：GitHub Pages 未启用

**问题：** 即使推送成功，访问 URL 仍显示 404

**必须做的步骤：**
```
1. 访问：https://github.com/username/username.github.io/settings/pages
2. Build and deployment → Source：选择 "Deploy from a branch"
3. Branch：选择 main，folder (root)
4. 点击 Save
5. 等待 1-3 分钟
```

**检查状态：**
- 绿色勾号 ✅ = 成功
- 黄色圆圈 ⏳ = 部署中
- 红色叉号 ❌ = 失败（查看错误信息）

### ⚠️ 注意事项 5：缓存问题

**问题：** 推送了新内容但网站没有更新

**解决方案：**
```bash
# 1. 重新清理和构建
npm run clean
npm run build
npm run deploy

# 2. 硬刷新浏览器
# Chrome/Firefox：Ctrl+Shift+R
# Safari：Cmd+Shift+R

# 3. 清除浏览器缓存
# Chrome DevTools (F12) → Application → Clear site data
```

### ⚠️ 注意事项 6：密钥文件权限

**错误信息：**
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@  WARNING: UNPROTECTED PRIVATE KEY FILE!  @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```

**解决：**
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/config
```

### ⚠️ 注意事项 7：部署前检查清单

```bash
#!/bin/bash
echo "=== 部署前检查 ==="

echo "1. 检查 Git 配置"
git remote -v | grep -q "username.github.io" && echo "✅ origin 正确" || echo "❌ origin 错误"

echo "2. 检查 Hexo 配置"
grep -q "repo: git@github.com:.*username.github.io.git" _config.yml && echo "✅ deploy.repo 正确" || echo "❌ deploy.repo 错误"
grep -q "branch: main" _config.yml && echo "✅ deploy.branch 正确" || echo "❌ deploy.branch 错误"

echo "3. 检查 SSH"
ssh -T git@github.com 2>&1 | grep -q "successfully" && echo "✅ SSH 连接成功" || echo "❌ SSH 连接失败"

echo "4. 检查源文件"
[ -d "source/_posts" ] && echo "✅ source 目录存在" || echo "❌ source 目录不存在"

echo -e "\n✅ 所有检查完成！可以部署了"
```

---

## 第四部分：原理解析

### 4.1 Hexo 工作原理

**三个阶段：**

```
阶段1：读取                    阶段2：渲染                   阶段3：输出
source/    -->  Hexo 解析  -->  处理          -->  public/
_posts/        ├─ 读取 MD     ├─ Markdown→HTML       ├─ index.html
about/         ├─ 解析 YAML   ├─ 应用主题           ├─ about/
               ├─ 检测标签    ├─ 生成页面           ├─ css/
               ├─ 处理资源    └─ 压缩资源           └─ js/
```

**具体步骤：**

1. **读取阶段**
   ```bash
   npm run build
   ```
   - 扫描 `source/` 下的所有 Markdown 文件
   - 解析 Front Matter（YAML头部）
   - 提取标题、日期、分类、标签等元数据

2. **渲染阶段**
   - Markdown → HTML（使用 hexo-renderer-marked）
   - 应用主题模板（使用 EJS/Nunjucks）
   - 生成导航、分类页、标签页等

3. **输出阶段**
   - 生成纯静态 HTML/CSS/JS 文件到 `public/`
   - 生成 sitemap（SEO）
   - 复制静态资源（图片、字体等）

**重要：** Hexo 只在**本地**运行，输出纯静态文件。

### 4.2 GitHub Pages 原理

**GitHub Pages 是什么？**
- 一个 HTTP 服务器，只提供静态文件
- **不运行任何服务器程序**（不支持 Node.js、PHP、Python 等）
- 只能展示 HTML、CSS、JS、图片等静态资源

**部署流程：**

```
npm run deploy
  ↓
读取 _config.yml 中的 deploy 配置
  ↓
克隆 git@github.com:username/username.github.io.git 到 .deploy_git/
  ↓
复制 public/* 到 .deploy_git/
  ↓
执行 git add / git commit / git push
  ↓
推送到 GitHub 的 main 分支
  ↓
GitHub Pages 服务器检测到 push
  ↓
自动将 main 分支的文件作为网站内容
  ↓
访问 https://username.github.io/ 时，GitHub 返回 main 分支中的 index.html
```

### 4.3 Hexo vs GitHub Pages 的关系

| 工具 | 运行位置 | 职责 | 理解框架? |
|-----|--------|------|---------|
| **Hexo** | 本地 | 源文件 → 静态网站 | ✅ 需要 |
| **GitHub Pages** | GitHub 服务器 | 提供静态文件 | ❌ 不需要 |

**重点：**
```
Hexo 生成的是纯 HTML/CSS/JS 文件
GitHub Pages 不知道你用了 Hexo
GitHub Pages 也不知道你的源文件在哪
GitHub Pages 只看 main 分支中的 HTML 文件
```

例如，你可以用其他工具生成博客：
```
Hugo → HTML → 推送到 GitHub Pages ✅ 可行
Jekyll → HTML → 推送到 GitHub Pages ✅ 可行
自己写 HTML → 推送到 GitHub Pages ✅ 可行
```

关键是最终产物必须是静态 HTML。

### 4.4 为什么本地 Hexo 服务和线上 Pages 不同？

**本地：** `npm run server`
```
npm run server 启动 Node.js 服务器
监听 http://localhost:4000/
实时编译 Markdown
支持热重载（修改文件自动刷新）
```

**线上：** GitHub Pages
```
纯 HTTP 服务器
提供已生成的 HTML 文件
无法实时编译
无法热重载
```

**推论：** 本地预览正常不代表线上一定正常：
- 本地用 Node.js 服务器，线上用 GitHub Pages
- 本地可能有缓存，线上没有
- 路径配置错误在本地可能看不出，线上会 404

---

## 第五部分：快捷脚本

### 5.1 一键部署脚本

创建 `scripts/deploy.sh`：

```bash
#!/bin/bash
set -e

echo "╔════════════════════════════════════════╗"
echo "║   Hexo Blog Deployment Script         ║"
echo "╚════════════════════════════════════════╝"

# 加载 nvm（如果需要）
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

echo "🧹 Step 1: Cleaning..."
npm run clean

echo "🔨 Step 2: Building..."
npm run build
BUILD_COUNT=$(find public -type f | wc -l)
echo "   ✅ Generated $BUILD_COUNT files"

echo "🚀 Step 3: Deploying to GitHub..."
npm run deploy

echo "✅ Deployment complete!"
echo "🌐 Visit: https://$(grep '^url:' _config.yml | awk '{print $2}' | sed 's|https://||;s|/||')"
```

使用：
```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

### 5.2 快速新文章脚本

创建 `scripts/new-post.sh`：

```bash
#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: ./new-post.sh \"Article Title\""
  exit 1
fi

TITLE="$1"
DATE=$(date +'%Y-%m-%d %H:%M:%S')
SLUG=$(echo "$TITLE" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

# 加载 nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

echo "📝 Creating new post: $TITLE"
npx hexo new "$TITLE"

FILENAME=$(find source/_posts -name "*${SLUG}*" -type f | head -1)

if [ -f "$FILENAME" ]; then
  echo "✅ Post created: $FILENAME"
  echo "📖 Edit with: nano $FILENAME"
fi
```

使用：
```bash
chmod +x scripts/new-post.sh
./scripts/new-post.sh "My New Article"
```

### 5.3 环境检查脚本

创建 `scripts/check-env.sh`：

```bash
#!/bin/bash

echo "╔════════════════════════════════════════╗"
echo "║   Environment Check                   ║"
echo "╚════════════════════════════════════════╝"

echo "1️⃣  Git"
if command -v git &> /dev/null; then
  echo "   ✅ Git: $(git --version)"
else
  echo "   ❌ Git not found"
fi

echo ""
echo "2️⃣  Node.js"
if command -v node &> /dev/null; then
  echo "   ✅ Node: $(node -v)"
else
  echo "   ❌ Node.js not found"
fi

echo ""
echo "3️⃣  npm"
if command -v npm &> /dev/null; then
  echo "   ✅ npm: $(npm -v)"
else
  echo "   ❌ npm not found"
fi

echo ""
echo "4️⃣  SSH Key"
if [ -f ~/.ssh/id_ed25519 ]; then
  echo "   ✅ Ed25519 key exists"
else
  echo "   ❌ Ed25519 key not found"
fi

echo ""
echo "5️⃣  GitHub SSH Connection"
if ssh -T git@github.com 2>&1 | grep -q "successfully"; then
  echo "   ✅ SSH connection successful"
else
  echo "   ❌ SSH connection failed"
fi

echo ""
echo "6️⃣  Hexo Configuration"
if [ -f "_config.yml" ]; then
  echo "   ✅ _config.yml exists"
  REPO=$(grep "repo:" _config.yml | awk '{print $2}')
  echo "   Deploy repo: $REPO"
else
  echo "   ❌ _config.yml not found"
fi
```

使用：
```bash
chmod +x scripts/check-env.sh
./scripts/check-env.sh
```

### 5.4 本地预览脚本

创建 `scripts/preview.sh`：

```bash
#!/bin/bash

echo "╔════════════════════════════════════════╗"
echo "║   Hexo Local Preview                  ║"
echo "╚════════════════════════════════════════╝"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

echo "📦 Building..."
npm run clean && npm run build

echo "🚀 Starting local server..."
echo "📍 Preview: http://localhost:4000/"
echo "⏹  Press Ctrl+C to stop"
echo ""

npm run server
```

使用：
```bash
chmod +x scripts/preview.sh
./scripts/preview.sh
```

---

## 快速参考

### 日常工作流

```bash
# 1. 新建文章
./scripts/new-post.sh "Article Title"
nano source/_posts/article-title.md

# 2. 本地预览
./scripts/preview.sh

# 3. 部署
./scripts/deploy.sh
```

### 常用命令

```bash
npm run clean        # 清理缓存
npm run build        # 构建
npm run server       # 本地预览
npm run deploy       # 部署到 GitHub
```

### 部署前检查

```bash
./scripts/check-env.sh
```

---

**下一步：** 根据注意事项检查你的配置，然后首次部署！
