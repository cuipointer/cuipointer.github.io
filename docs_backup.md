# Hexo + GitHub Pages 个人博客搭建完整教程

## 📋 目录

1. [环境准备](#环境准备)
2. [Hexo 项目初始化](#hexo-项目初始化)
3. [Cactus 主题安装与配置](#cactus-主题安装与配置)
4. [GitHub Pages 部署配置](#github-pages-部署配置)
5. [博客文章撰写](#博客文章撰写)
6. [本地预览与发布](#本地预览与发布)
7. [常见问题与调试](#常见问题与调试)

---

## 🛠 环境准备

### 1. Node.js 环境

**方式一：使用 NVM（推荐）**

```bash
# 安装 NVM
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# 加载 NVM
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"

# 安装 Node.js LTS 版本
nvm install --lts
nvm use --lts

# 验证安装
node -v  # 应显示 v24.x.x
npm -v   # 应显示 11.x.x
```

**方式二：系统包管理器**

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nodejs npm

# macOS
brew install node
```

### 2. Git 配置

```bash
# 安装 Git
sudo apt install git  # Ubuntu/Debian
brew install git      # macOS

# 配置 Git 用户信息
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# 配置 SSH 密钥（推荐）
ssh-keygen -t rsa -C "your@email.com"
cat ~/.ssh/id_rsa.pub  # 复制公钥到 GitHub Settings -> SSH Keys
```

---

## 🚀 Hexo 项目初始化

### 1. 创建项目目录

```bash
mkdir my-blog
cd my-blog
```

### 2. 初始化 Hexo

```bash
# 方式一：全局安装 Hexo CLI
npm install -g hexo-cli
hexo init .
npm install

# 方式二：使用 npx（推荐，无需全局安装）
npx hexo init .
npm install
```

### 3. 项目结构

```
my-blog/
├── _config.yml          # 站点配置文件
├── package.json         # Node.js 依赖配置
├── scaffolds/           # 文章模板
├── source/              # 源文件目录
│   └── _posts/          # 博客文章目录
├── themes/              # 主题目录
└── public/              # 生成的静态文件（构建后）
```

---

## 🎨 Cactus 主题安装与配置

### 1. 安装主题

```bash
cd themes/
git clone https://github.com/probberechts/hexo-theme-cactus.git cactus
cd ..
```

### 2. 配置主题

编辑根目录 `_config.yml`，修改以下配置：

```yaml
# 站点信息
title: Cuihan's Blog
subtitle: '技术分享与个人思考'
description: '记录学习与生活'
keywords:
  - 技术博客
  - Hexo
  - GitHub Pages
author: Cuihan
language: zh-CN
timezone: 'Asia/Shanghai'

# URL配置（重要！）
url: https://cuipointer.github.io/cuihan
root: /cuihan/

# 主题配置
theme: cactus
```

### 3. 主题细节配置

复制主题配置文件到根目录：

```bash
cp themes/cactus/_config.yml _config.cactus.yml
```

编辑 `_config.cactus.yml`（可选配置）：

```yaml
# 导航菜单
nav:
  home: /
  about: /about/
  articles: /archives/
  tags: /tags/
  
# 社交链接
social_links:
  github: https://github.com/cuipointer
  
# 代码高亮主题
highlight: atom-one-dark

# 文章目录
toc:
  enable: true
```

---

## 🌐 GitHub Pages 部署配置

### 1. 创建 GitHub 仓库

1. 访问 GitHub 创建新仓库：`cuihan`
2. 仓库地址：`git@github.com:cuipointer/cuihan.git`
3. **重要**：仓库设置 -> Pages -> Source 选择 `gh-pages` 分支

### 2. 安装部署插件

```bash
npm install hexo-deployer-git --save
```

### 3. 配置部署信息

编辑 `_config.yml` 底部：

```yaml
# Deployment
deploy:
  type: git
  repo: git@github.com:cuipointer/cuihan.git
  branch: gh-pages
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
```

### 4. GitHub Actions 自动部署（可选）

创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy Hexo

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          
      - name: Install Dependencies
        run: npm ci
        
      - name: Build
        run: npm run build
        
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

---

## ✍️ 博客文章撰写

### 1. 创建新文章

```bash
# 创建文章
hexo new "我的第一篇博客"

# 创建草稿
hexo new draft "草稿文章"

# 发布草稿
hexo publish "草稿文章"
```

### 2. 文章 Front Matter

```markdown
---
title: 文章标题
date: 2026-03-04 10:00:00
tags:
  - 标签1
  - 标签2
categories:
  - 分类名称
cover: /images/cover.jpg
description: 文章摘要描述
---

这里开始正文内容...
```

### 3. 创建关于页面

```bash
hexo new page "about"
```

编辑 `source/about/index.md`：

```markdown
---
title: 关于我
date: 2026-03-04
type: about
---

这里写关于页面内容...
```

---

## 🖥 本地预览与发布

### 1. 本地预览

```bash
# 清理缓存
hexo clean

# 生成静态文件
hexo generate
# 或简写
hexo g

# 启动本地服务器
hexo server
# 或简写
hexo s

# 访问 http://localhost:4000
```

### 2. 发布到 GitHub Pages

```bash
# 清理 + 生成 + 部署（一键发布）
hexo clean && hexo generate && hexo deploy
# 或简写
hexo clean && hexo g -d
```

### 3. 首次推送源码

```bash
# 初始化 Git 仓库
git init
git add .
git commit -m "Initial commit"

# 关联远程仓库
git remote add origin git@github.com:cuipointer/cuihan.git

# 推送到 main 分支（保留源码）
git branch -M main
git push -u origin main
```

**分支说明：**
- `main` 分支：存储 Hexo 源码
- `gh-pages` 分支：存储生成的静态网站（自动创建）

---

## 🔧 常见问题与调试

### 问题 1：部署后页面样式丢失

**原因**：`_config.yml` 中 `url` 和 `root` 配置不正确

**解决**：
```yaml
# 仓库名为 cuihan
url: https://cuipointer.github.io/cuihan
root: /cuihan/
```

### 问题 2：本地预览正常，部署后 404

**原因**：GitHub Pages 分支配置错误

**解决**：
1. 检查仓库 Settings -> Pages -> Branch 是否为 `gh-pages`
2. 确认 `hexo deploy` 推送到了 `gh-pages` 分支

### 问题 3：SSH 推送失败

**原因**：未配置 SSH 密钥或权限不足

**解决**：
```bash
# 测试 SSH 连接
ssh -T git@github.com

# 如果失败，生成并添加 SSH 密钥
ssh-keygen -t rsa -C "your@email.com"
cat ~/.ssh/id_rsa.pub  # 添加到 GitHub
```

### 问题 4：依赖安装失败

**原因**：网络问题或 npm 源慢

**解决**：
```bash
# 使用国内镜像源
npm config set registry https://registry.npmmirror.com

# 清除 npm 缓存
npm cache clean --force

# 重新安装
rm -rf node_modules package-lock.json
npm install
```

### 调试技巧

```bash
# 查看 Hexo 版本
hexo version

# 查看详细日志
hexo g --debug

# 安全模式启动（禁用插件）
hexo s --safe

# 指定端口
hexo s -p 5000
```

---

## 📦 一键化脚本

### 完整部署脚本

创建 `deploy.sh`：

```bash
#!/bin/bash
set -euo pipefail

echo "🚀 开始部署博客..."

# 加载 Node.js 环境
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use --lts >/dev/null

# 清理并构建
echo "📦 清理旧文件..."
npm run clean

echo "🔨 生成静态文件..."
npm run build

echo "📤 部署到 GitHub Pages..."
npm run deploy

echo "✅ 部署完成！"
echo "🌐 访问：https://cuipointer.github.io/cuihan"
```

### 新建文章快捷脚本

创建 `new_post.sh`：

```bash
#!/bin/bash
read -p "📝 输入文章标题: " title
npx hexo new "$title"
echo "✅ 文章已创建：source/_posts/$title.md"
```

---

## 🎯 总结

### 核心命令速查

| 命令 | 说明 |
|------|------|
| `hexo init` | 初始化博客 |
| `hexo new "title"` | 新建文章 |
| `hexo clean` | 清理缓存 |
| `hexo generate` / `hexo g` | 生成静态文件 |
| `hexo server` / `hexo s` | 启动本地服务器 |
| `hexo deploy` / `hexo d` | 部署到远程 |
| `hexo g -d` | 生成并部署 |

### 工作流程

1. **写作**：`hexo new "标题"` → 编辑 Markdown
2. **预览**：`hexo clean && hexo s`
3. **发布**：`hexo clean && hexo g -d`
4. **备份源码**：`git add . && git commit -m "update" && git push`

---

**最后更新**：2026-03-04  
**作者**：Cuihan  
**仓库**：https://github.com/cuipointer/cuihan
