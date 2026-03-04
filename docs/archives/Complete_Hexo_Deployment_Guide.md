# Hexo + GitHub Pages 完整部署教程（从零开始）

> 本文档是从零开始搭建 Hexo 博客并部署到 GitHub Pages 的完整步骤指南。如果你环境已经部分就绪，可以跳过对应步骤。

---

## 第一部分：环境准备

### 步骤 1.1：安装 Git

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install git

# macOS
brew install git

# 验证安装
git --version  # git version 2.x.x 或更新
```

### 步骤 1.2：安装 Node.js 和 npm

使用 nvm（Node Version Manager）可以轻松管理 Node 版本：

```bash
# 1. 安装 nvm
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# 2. 重新加载 shell 配置（或重新打开终端）
source ~/.bashrc
# 或
source ~/.zshrc

# 3. 安装最新 LTS 版本的 Node.js
nvm install --lts

# 4. 设置默认版本
nvm alias default lts/*

# 5. 验证安装
node -v   # v20.x.x 或更新
npm -v    # v11.x.x 或更新
```

### 步骤 1.3：生成 SSH 密钥

用于 GitHub 推送认证：

```bash
# 1. 生成 ed25519 密钥（推荐，比 RSA 更安全）
ssh-keygen -t ed25519 -C "your@email.com" -f ~/.ssh/id_ed25519

# 按 Enter 接受默认位置和空密码（或设置密码）

# 2. 如果系统不支持 ed25519，使用 RSA 代替
ssh-keygen -t rsa -b 4096 -C "your@email.com" -f ~/.ssh/id_rsa

# 3. 查看公钥
cat ~/.ssh/id_ed25519.pub
# 输出：ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... your@email.com
```

### 步骤 1.4：添加 SSH 密钥到 GitHub

```
1. 打开：https://github.com/settings/keys
2. 点击 "New SSH key"
3. 标题：输入任意名称（如 "My Laptop"）
4. Key 类型：选择 "Authentication Key"
5. Key 内容：粘贴上面的公钥内容（整个 ssh-ed25519 ... 这一行）
6. 点击 "Add SSH key"
```

### 步骤 1.5：配置 SSH（可选但推荐）

创建 `~/.ssh/config` 文件简化 SSH 连接：

```bash
# 创建配置文件
cat > ~/.ssh/config <<'EOF'
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  AddKeysToAgent yes
EOF

# 设置正确的权限
chmod 600 ~/.ssh/config
chmod 700 ~/.ssh

# 测试 SSH 连接
ssh -T git@github.com
# 预期输出：Hi username! You've successfully authenticated...
```

---

## 第二部分：GitHub 仓库准备

### 步骤 2.1：创建 GitHub 用户 Pages 仓库

GitHub Pages 有两种模式：
- **用户页面**：`username.github.io`（你使用这个）
- **项目页面**：`username/project-name`

**为了运行 Hexo 博客，你需要用户页面：**

```
1. 访问：https://github.com/new
2. Repository name：输入 username.github.io
   （例如：cuipointer.github.io）
3. Description：可选，如 "My Personal Blog"
4. Public：选择公开（必须）
5. 不要勾选"Add a README file"
6. 点击 "Create repository"
```

创建后，你将获得一个空的仓库：
```
https://github.com/username/username.github.io
```

### 步骤 2.2：创建源代码仓库（可选但推荐）

为了备份 Hexo 源文件，建议创建第二个仓库存储源代码：

```
1. 访问：https://github.com/new
2. Repository name：输入 hexo-blog 或 blog 或任意名称
   （例如：cuihan）
3. 其他配置同上
4. 点击 "Create repository"
```

这样你有两个仓库：
- `cuipointer.github.io`：存储生成的静态网站（由 Hexo 自动推送）
- `cuihan`（或其他名字）：存储 Hexo 源代码和配置

---

## 第三部分：本地 Hexo 项目

### 步骤 3.1：初始化 Hexo 项目

```bash
# 1. 选择一个工作目录
mkdir -p ~/Projects
cd ~/Projects

# 2. 使用 Hexo 官方模板初始化
# 方法 A：使用 npx（推荐）
npx hexo-cli init blog

# 方法 B：全局安装 hexo-cli 后初始化
npm install -g hexo-cli
hexo init blog

# 3. 进入项目目录
cd blog

# 4. 安装项目依赖
npm install
```

### 步骤 3.2：项目结构说明

生成的 `blog` 目录结构：

```
blog/
├── _config.yml              # Hexo 主配置文件 ⭐ 最重要
├── _config.landscape.yml    # 主题配置（如果用 landscape 主题）
├── package.json             # Node.js 依赖配置
├── package-lock.json
├── source/                  # 源文件目录
│   ├── _posts/              # 博客文章（Markdown 文件）
│   └── _data/               # 数据文件（可选）
├── themes/                  # 主题目录
│   └── landscape/           # 默认主题
├── public/                  # 生成的静态文件（运行 npm run build 后生成）
├── .gitignore               # Git 忽略文件
└── node_modules/            # 依赖包（不要提交到 Git）
```

### 步骤 3.3：本地预览

```bash
# 构建静态文件
npm run build

# 启动本地服务器
npm run server

# 访问
# http://localhost:4000/
# 你应该看到默认的 Hexo 示例博客
```

按 `Ctrl+C` 停止服务器。

---

## 第四部分：配置 Hexo

这是**最关键**的部分。所有配置都在 `_config.yml` 文件中。

### 步骤 4.1：配置基本信息

编辑 `_config.yml`，修改以下部分：

```yaml
# Site 部分
title: My Awesome Blog              # 博客标题
subtitle: ''                         # 副标题
description: 'A blog powered by Hexo' # 描述
keywords: blog, hexo, programming    # 关键词
author: Your Name                    # 作者
language: en                         # 语言（en, zh-CN, zh-TW 等）
timezone: Asia/Shanghai              # 时区

# URL 部分（⭐ 重要）
## 如果你部署到 https://username.github.io/
## 那么配置：
url: https://username.github.io/     # 替换 username
root: /                               # 用户页面用 /，项目页面用 /project-name/
```

### 步骤 4.2：配置部署

编辑 `_config.yml` 的 `deploy` 部分：

```yaml
# Deployment
deploy:
  type: git
  repo: git@github.com:username/username.github.io.git  # ⭐ 替换为你的用户 Pages 仓库
  branch: main                                           # ⭐ 用户页面用 main
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
```

**配置说明：**
| 参数 | 值 | 说明 |
|-----|-----|------|
| type | git | 使用 Git 部署 |
| repo | `git@github.com:username/username.github.io.git` | GitHub Pages 仓库地址 |
| branch | main | 用户页面必须是 main（不是 gh-pages） |
| message | 自定义 | 每次部署的 commit 信息 |

### 步骤 4.3：安装部署插件

Hexo 依赖 `hexo-deployer-git` 插件来推送到 GitHub：

```bash
npm install hexo-deployer-git --save
```

---

## 第五部分：更换主题（可选）

Hexo 默认主题是 Landscape。如果想换更美观的主题：

### 步骤 5.1：安装主题

以 Cactus 主题为例：

```bash
# 1. 进入项目目录
cd ~/Projects/blog

# 2. 安装主题
git clone https://github.com/probberechts/hexo-theme-cactus.git themes/cactus

# 3. 修改 _config.yml 中的 theme 选项
theme: cactus

# 4. 创建主题配置文件（可选）
cp themes/cactus/_config.yml _config.cactus.yml
```

### 步骤 5.2：主题配置

不同主题的配置方式不同，参考对应主题的 README。

例如，Cactus 主题可以配置：
- 导航菜单
- 社交链接
- 颜色主题
- 等等

---

## 第六部分：创建文章

### 步骤 6.1：新建文章

**方法 A：使用 Hexo 命令**
```bash
npx hexo new "My First Post"

# 生成：source/_posts/My-First-Post.md
```

**方法 B：手动创建**
```bash
# 在 source/_posts/ 目录下创建 Markdown 文件
cat > source/_posts/my-first-post.md <<'EOF'
---
title: My First Post
date: 2026-03-04 10:00:00
tags:
  - Hexo
  - Blog
categories:
  - Tutorial
---

这是我的第一篇博客文章。

## 第一个标题

这是内容...
EOF
```

### 步骤 6.2：文章 Front Matter 说明

每篇文章的开头需要 YAML 元数据（Front Matter）：

```yaml
---
title: 文章标题
date: 2026-03-04 10:00:00
updated: 2026-03-04 11:00:00    # 可选：更新时间
tags:                             # 可选：标签
  - 标签1
  - 标签2
categories:                       # 可选：分类
  - 分类1
description: 文章摘要描述         # 可选：SEO 描述
---

文章正文从这里开始...
```

### 步骤 6.3：本地预览

```bash
# 在项目根目录执行
npm run server

# 访问 http://localhost:4000/
# 刷新浏览器看到最新内容
```

---

## 第七部分：初始化 Git 仓库

### 步骤 7.1：关联源代码仓库

如果你创建了源代码仓库（如 `cuihan`），绑定它：

```bash
cd ~/Projects/blog

# 初始化 Git 仓库
git init

# 添加远程仓库
git remote add origin git@github.com:username/cuihan.git

# 验证
git remote -v
# origin    git@github.com:username/cuihan.git (fetch)
# origin    git@github.com:username/cuihan.git (push)
```

### 步骤 7.2：创建 .gitignore

确保不提交不必要的文件：

```bash
# 如果文件不存在，创建它
cat > .gitignore <<'EOF'
# Logs
logs
*.log
npm-debug.log*

# Dependencies
node_modules/

# Generated files
public/
.deploy_git/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Build output
dist/
build/
EOF
```

### 步骤 7.3：提交源代码

```bash
# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: Hexo blog setup"

# 推送到远程（第一次需要 -u）
git push -u origin main
```

---

## 第八部分：部署到 GitHub Pages

### 步骤 8.1：生成并部署

```bash
# 清理旧的构建文件
npm run clean

# 生成新的静态文件
npm run build

# 部署到 GitHub Pages
npm run deploy

# 预期输出：
# INFO  Deploying: git
# ...
# To github.com:username/username.github.io.git
#  + abcd123...efgh456  HEAD -> main
# INFO  Deploy done: git
```

### 步骤 8.2：在 GitHub 启用 Pages

**这一步⚠️ 不能跳过：**

```
1. 访问：https://github.com/username/username.github.io/settings/pages
2. 向下滚动到 "Build and deployment" 部分
3. Source：选择 "Deploy from a branch"
4. Branch：选择 main，文件夹选择 (root)
5. 点击 Save
```

### 步骤 8.3：等待部署完成

- GitHub 会自动部署，通常需要 1-3 分钟
- 页面顶部会显示状态：
  - 🟢 成功：显示绿色勾号 + "Your site is live at https://username.github.io/"
  - 🟡 进行中：显示黄色圆圈
  - 🔴 失败：显示红色叉号 + 错误信息

### 步骤 8.4：访问你的博客

```
https://username.github.io/
```

恭喜！你的 Hexo 博客已上线！

---

## 第九部分：日常发布流程

### 默认工作流

每次发布新文章的流程：

```bash
# 1. 新建文章
npx hexo new "Article Title"

# 2. 编辑文章
nano source/_posts/article-title.md
# 或用你的编辑器打开：source/_posts/article-title.md

# 3. 本地预览
npm run server
# 访问 http://localhost:4000/ 检查效果

# 4. 提交源代码（如果你有源代码仓库）
git add .
git commit -m "Add: New article about ..."
git push origin main

# 5. 生成和部署
npm run clean
npm run build
npm run deploy

# 6. 等待 1-3 分钟，访问博客验证
```

### 快捷脚本（可选）

创建 `deploy.sh` 脚本一键部署：

```bash
cat > deploy.sh <<'EOF'
#!/bin/bash
set -e
echo "🧹 Cleaning..."
npm run clean
echo "🔨 Building..."
npm run build
echo "🚀 Deploying..."
npm run deploy
echo "✅ Done! Visit: https://cuipointer.github.io/"
EOF

chmod +x deploy.sh
```

使用：
```bash
./deploy.sh
```

---

## 第十部分：常见问题解决

### Q1：部署成功但显示 404

**原因：** Pages 未启用或配置错误

**解决：**
```
1. 访问 Settings → Pages
2. 确认 Source = "Deploy from a branch"
3. 确认 Branch = main (root)
4. 点击 Save
5. 等待 2-5 分钟后刷新
```

### Q2：部署时出现 "Permission denied (publickey)"

**原因：** SSH 密钥未正确配置

**解决：**
```bash
# 测试 SSH 连接
ssh -T git@github.com

# 如果失败，检查：
# 1. 公钥是否添加到 GitHub (https://github.com/settings/keys)
# 2. ~/.ssh/config 是否正确配置
# 3. 权限是否正确：chmod 600 ~/.ssh/config && chmod 700 ~/.ssh
```

### Q3：页面显示但样式混乱

**原因：** HTML 中的资源路径错误

**解决：**
```yaml
# 检查 _config.yml
url: https://username.github.io/     # 必须以 / 结尾
root: /                               # 用户页面必须是 /
```

### Q4：本地预览正常但线上看不到更新

**原因：** 缓存或部署未完成

**解决：**
```bash
# 1. 再次部署
npm run clean && npm run build && npm run deploy

# 2. 等待几分钟

# 3. 硬刷新浏览器（Ctrl+Shift+R）

# 4. 清除浏览器缓存
# 打开开发者工具 (F12)
# Application → Clear site data
```

### Q5：如何更新已发布的文章？

```bash
# 1. 编辑文章
nano source/_posts/old-article.md

# 2. 本地预览
npm run server

# 3. 重新部署
npm run clean && npm run build && npm run deploy

# 4. 提交源代码（如果有）
git add .
git commit -m "Update: Old article"
git push origin main
```

---

## 最终检查清单

部署前：
- [ ] Node.js 和 npm 已安装 (`node -v` && `npm -v`)
- [ ] SSH 密钥已添加到 GitHub (`ssh -T git@github.com`)
- [ ] GitHub Pages 仓库已创建 (`username.github.io`)
- [ ] `_config.yml` 中 `deploy.repo` 正确
- [ ] `_config.yml` 中 `url` 和 `root` 正确
- [ ] Hexo 本地预览正常 (`npm run server`)

部署后：
- [ ] `npm run deploy` 返回 "Deploy done: git"
- [ ] 检查 GitHub Pages 仓库有新提交
- [ ] GitHub Settings → Pages 已启用
- [ ] 等待 1-3 分钟
- [ ] 访问 `https://username.github.io/` 能看到内容

---

## 快速参考命令

```bash
# 初始化和依赖
npx hexo init blog                 # 初始化新博客
cd blog && npm install             # 安装依赖

# 日常编辑
npx hexo new "Title"              # 新建文章
npm run server                    # 本地预览（localhost:4000）

# 发布
npm run clean                     # 清理缓存
npm run build                     # 生成静态文件
npm run deploy                    # 部署到 GitHub Pages

# 源代码管理
git add .                         # 暂存更改
git commit -m "message"           # 提交
git push origin main              # 推送到 GitHub

# 组合命令
npm run clean && npm run build && npm run deploy   # 一键部署
```

---

## 推荐阅读

- [Hexo 官方文档](https://hexo.io/docs/)
- [GitHub Pages 官方指南](https://pages.github.com/)
- [SSH 密钥配置](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Markdown 语法](https://www.markdownguide.org/)

---

**本教程适用于：** Hexo 8.x, Node.js 18+  
**更新日期：** 2026-03-04  
**难度级别：** 初级到中级
