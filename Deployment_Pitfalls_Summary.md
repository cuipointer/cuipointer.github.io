# Hexo + GitHub Pages 部署"坑"复盘总结

## 部署过程中踩过的坑

本文档记录从零到完成部署过程中所有遇到的问题、原因及解决方案。

---

## 坑 #1：SSH 密钥认证失败

### 问题表现
```
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.
```

### 根本原因
- 系统中存在 SSH 密钥但**未添加到 GitHub 账户**
- GitHub 服务器无法识别本地密钥

### 踩坑过程
1. 用 `git@` 前缀尝试克隆仓库 → 失败
2. 尝试 SSH 连接测试 → Permission denied
3. 意识到需要将本地公钥添加到 GitHub

### 解决方案
```bash
# 1. 查看本地公钥
cat ~/.ssh/id_ed25519.pub
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmlvYjJd99weVBnC4x+3UpybNS2...

# 2. 访问 GitHub 添加公钥
访问：https://github.com/settings/keys
点击 "New SSH key"
粘贴上面的公钥内容
保存

# 3. 配置 ~/.ssh/config，指定 GitHub 使用该密钥
cat > ~/.ssh/config <<'EOF'
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  AddKeysToAgent yes
EOF

# 4. 权限设置
chmod 600 ~/.ssh/config
chmod 700 ~/.ssh
```

### 经验总结
- ✅ 在推送前始终用 `ssh -T git@github.com` 测试连接
- ✅ 第一次配置时，务必在 GitHub 网页端完成密钥注册
- ✅ SSH config 文件需要严格的权限设置（600）

---

## 坑 #2：远程仓库地址混乱

### 问题表现
```bash
git remote -v
# 显示多个 remote，或显示错误的仓库地址
```

### 根本原因
- 在修复过程中多次修改 `remote origin` 指向
- 没有重新梳理两个仓库的用途（源码仓 vs 发布仓）

### 踩坑过程
1. 初始：`origin` → `git@github.com:cuipointer/cuihan.git`
2. 然后：改成 `git@github.com:cuipointer/cuipointer.github.io.git`（为了推送源码）
3. 混乱：部署时应该指向 `cuipointer.github.io.git`，源码推送也是到同一地址
4. 最终：需要分离 origin（源码仓）和 deploy target（Pages 仓）

### 解决方案

**理解两个仓库的角色：**

| 仓库 | 用途 | 分支 | 内容 |
|-----|------|------|------|
| `cuihan` | 源代码仓库 | main | Hexo 配置、文章源文件、主题 |
| `cuipointer.github.io` | GitHub Pages 仓库 | main | 生成的静态 HTML/CSS/JS |

**配置策略：**
```bash
# 在源代码仓目录中
cd /home/cuihan/cuihan

# origin 始终指向源代码仓
git remote set-url origin git@github.com:cuipointer/cuihan.git

# 在 _config.yml 中指定部署目标（不用 remote）
deploy:
  type: git
  repo: git@github.com:cuipointer/cuipointer.github.io.git  # 部署使用这个
  branch: main
```

**操作流程：**
```bash
# 开发时：源码提交到 cuihan
git add .
git commit -m "Update posts"
git push origin main  # 推到 cuihan

# 发布时：Hexo 自动推送到 cuipointer.github.io
npm run deploy         # 自动推到 cuipointer.github.io
```

### 经验总结
- ✅ **源代码仓和发布仓是分离的**，不要混淆
- ✅ `git remote` 只管理源代码仓库
- ✅ 部署目标在 `_config.yml` 中单独配置
- ✅ 执行 `git remote -v` 检查 origin 是否正确

---

## 坑 #3：部署配置指向错误的仓库

### 问题表现
```
INFO  Deploying: git
...
To github.com:cuipointer/cuihan.git
 ✓ Done
```
但打开 `https://cuipointer.github.io/` 显示 404，页面不存在。

### 根本原因
```yaml
# _config.yml 中的错误配置
deploy:
  type: git
  repo: git@github.com:cuipointer/cuihan.git      # ❌ 错误！是源码仓
  branch: gh-pages                                  # ❌ 错误！这个分支不存在
```

Hexo 把生成的静态文件推到了错误的仓库和分支。

### 踩坑过程
1. 第一次部署后，检查 `cuipointer.github.io` 的 `main` 分支 → 没有新文件
2. 反而看到 `cuihan` 仓库里多了 `.deploy_git` 目录
3. 才意识到 `deploy.repo` 指向了错误的仓库

### 解决方案
```yaml
# ✅ 正确的配置
deploy:
  type: git
  repo: git@github.com:cuipointer/cuipointer.github.io.git  # 用户 Pages 仓库
  branch: main                                                # 用户页面用 main
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
```

**重新部署：**
```bash
npm run clean    # 清理旧的缓存和生成文件
npm run build    # 重新生成
npm run deploy   # 推送到正确的仓库
```

### 经验总结
- ✅ 用户 GitHub Pages 仓库名必须是 `username.github.io`
- ✅ 部署分支对于用户页面是 `main`，对于项目页面是 `gh-pages`
- ✅ 执行部署前，用 `grep 'deploy:' -A 5 _config.yml` 验证配置
- ✅ 部署后，检查 `cuipointer.github.io` 仓库的 main 分支是否有新提交

---

## 坑 #4：URL 和 root 路径配置错误

### 问题表现
网页能打开，但：
- CSS 样式加载失败（资源 404）
- 链接指向错误的路径
- 网站显示混乱

### 根本原因
```yaml
# _config.yml 中的错误配置
url: https://cuipointer.github.io/cuihan        # ❌ 多了 /cuihan/
root: /cuihan/                                   # ❌ 错误的子路径

# 这会导致生成的 HTML 中：
# <link rel="stylesheet" href="/cuihan/css/style.css">
# 但实际访问时，浏览器请求的是 /cuihan/css/style.css
# GitHub Pages 会返回 404
```

### 踩坑过程
1. 看到生成的 HTML 源码，资源链接多了 `/cuihan/`
2. 才意识到 Hexo 配置中 `root:` 参数的作用
3. 这个参数原本是为了支持项目页面（子路径部署）的配置

### 解决方案
```yaml
# ✅ 用户页面（根域名）的正确配置
url: https://cuipointer.github.io/
root: /

# 这会生成：
# <link rel="stylesheet" href="/css/style.css">
# 浏览器能正确请求到资源
```

**配置表对比：**
| 场景 | url | root |
|-----|-----|------|
| 用户页面（你的情况） | `https://cuipointer.github.io/` | `/` |
| 项目页面 | `https://cuipointer.github.io/project/` | `/project/` |

### 经验总结
- ✅ **用户页面永远用根路径** `root: /`
- ✅ 项目页面才需要设置子路径
- ✅ 修改后必须执行 `npm run clean` 清除旧的生成缓存
- ✅ 用浏览器开发者工具（F12）查看加载的资源路径，检查是否正确

---

## 坑 #5：GitHub Pages 网页配置被遗漏

### 问题表现
```
已经推送了静态文件到 cuipointer.github.io 的 main 分支
但访问 https://cuipointer.github.io/ 仍显示 404
```

### 原因分析
GitHub Pages 需要**两个条件同时满足**：
1. ✅ 仓库中有静态文件
2. ❌ **还需要在 GitHub 网页端手动"启用" Pages**

许多人以为只要推送文件就行，忘了这一步。

### 踩坑过程
1. 部署完成，检查 `cuipointer.github.io` 仓库 → 文件已推送
2. 访问 `https://cuipointer.github.io/` → 404 错误
3. 查看仓库的 Settings → 发现 Pages 根本没有启用

### 解决方案

**必须手动配置 GitHub Pages：**

1. 打开仓库设置
   ```
   https://github.com/cuipointer/cuipointer.github.io/settings/pages
   ```

2. 在 **Build and deployment** 部分：
   - Source: `Deploy from a branch`
   - Branch: `main`
   - Folder: `(root)`

3. 点击 **Save**

4. 等待 1-3 分钟，GitHub 会自动部署

**验证部署状态：**
- 成功：页面顶部显示绿色勾号 + "Your site is live at ..."
- 进行中：显示黄色圆圈 + "Waiting on a check run"
- 失败：显示红色叉号 + 错误信息

### 经验总结
- ✅ **这不是可选的！必须在网页端启用 Pages**
- ✅ 第一次部署 GitHub Pages 一定要记得这一步
- ✅ 如果 404，先检查这个设置，再检查代码
- ✅ 部署完成后要等待几分钟再访问（GitHub 需要时间）

---

## 坑 #6：Node.js / npm 未安装

### 问题表现
```bash
$ npm install
Command 'npm' not found, but can be installed with:
    sudo apt install npm
```

### 根本原因
系统中未安装 Node.js 和 npm，但这是运行 Hexo 的必须环境。

### 解决方案

**方案 A：使用 nvm（推荐，用户级安装）**
```bash
# 1. 安装 nvm
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# 2. 加载 nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# 3. 安装 Node.js LTS 版本
nvm install --lts

# 4. 使用该版本
nvm use --lts

# 5. 验证
node -v   # v20.x.x 或更新
npm -v    # v11.x.x 或更新
```

**方案 B：使用系统包管理器（简单但可能版本过旧）**
```bash
sudo apt update
sudo apt install nodejs npm
```

### 经验总结
- ✅ **用 nvm 更灵活**，可以轻松切换 Node 版本
- ✅ nvm 使用后，每次打开新终端需要 `. ~/.nvm/nvm.sh`
- ✅ 建议在 `~/.bashrc` 或 `~/.zshrc` 中加入 nvm 初始化代码

---

## 坑 #7：本地预览没有生效

### 问题表现
```bash
$ npm run server
# 没有输出，或输出不完整
$ 访问 http://localhost:4000 → 连接被拒绝
```

### 原因分析
- `npm run server` 启动后，需要等待初始化
- 如果在终端中阻塞，看不到这个过程
- 或者命令在后台运行但没有正确启动

### 解决方案

**检查端口是否监听：**
```bash
# 在另一个终端中执行
ss -ltnp | grep ':4000'
# 如果看到 LISTEN 表示成功，没有则失败
```

**重新启动服务：**
```bash
cd /home/cuihan/cuihan
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# 前台运行
npm run server

# 或后台运行
npm run server > server.log 2>&1 &

# 监控日志
tail -f server.log
```

### 经验总结
- ✅ 使用 `ss -ltnp | grep :4000` 检查端口状态
- ✅ 启动 Hexo 服务器需要 2-10 秒的初始化时间
- ✅ 如果需要后台运行，用 `&` 或用专门的进程管理器

---

## 坑 #8：文件权限问题

### 问题表现
```bash
$ git push
Permission denied: /home/cuihan/.ssh/config
```

或 SSH 连接时：
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@        WARNING: UNPROTECTED PRIVATE KEY FILE!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```

### 原因分析
SSH 密钥文件或配置文件的权限设置不当。

### 解决方案
```bash
# 设置正确的权限
chmod 700 ~/.ssh                      # 目录：700
chmod 600 ~/.ssh/id_ed25519           # 私钥：600
chmod 644 ~/.ssh/id_ed25519.pub       # 公钥：644
chmod 600 ~/.ssh/config               # 配置：600
chmod 600 ~/.ssh/known_hosts          # 已知主机：600

# 验证
ls -la ~/.ssh/
# 应该看到类似：
# drwx------  2 cuihan cuihan 4096 Mar  4 23:06 .
# -rw-------  1 cuihan cuihan  411 Mar  4 23:06 id_ed25519
# -rw-------  1 cuihan cuihan   99 Mar  4 23:06 id_ed25519.pub
# -rw-------  1 cuihan cuihan  124 Mar  4 23:06 config
```

### 经验总结
- ✅ SSH 目录必须是 `700`，文件必须是 `600`
- ✅ SSH 永远不要使用 `chmod 777`
- ✅ 权限问题是 SSH 最常见的错误之一

---

## 完整坑点速查表

| # | 坑点 | 症状 | 解决方案 |
|----|-----|------|--------|
| 1 | SSH 密钥未授权 | Permission denied | 添加公钥到 GitHub settings |
| 2 | 远程仓库混乱 | git remote 指向错误 | 用 origin 管理源码仓，deploy 配置管理发布仓 |
| 3 | deploy.repo 错误 | 文件推送到源码仓，不是 Pages 仓 | 改为 `cuipointer.github.io.git` |
| 4 | URL/root 错误 | 资源 404，样式混乱 | 用户页面设置 `root: /` `url: .../` |
| 5 | Pages 未启用 | 显示 404，无法访问 | 在 GitHub Settings → Pages 手动启用 |
| 6 | Node.js 未装 | npm 命令不存在 | 用 nvm 或系统包管理器安装 |
| 7 | 本地预览失败 | 无法连接 localhost:4000 | 检查端口、等待初始化 |
| 8 | 文件权限错误 | SSH 警告、拒绝连接 | chmod 设置 ~/.ssh 权限 |

---

## 优化建议

### 部署前清单
- [ ] SSH 密钥已添加到 GitHub
- [ ] `_config.yml` 中的 `deploy.repo` 正确指向 `cuipointer.github.io.git`
- [ ] `_config.yml` 中的 `deploy.branch` 是 `main`
- [ ] `_config.yml` 中的 `url` 和 `root` 与你的部署方式匹配
- [ ] 执行了 `npm run clean`
- [ ] `git push origin main` 推送了源代码
- [ ] 已在 GitHub Settings → Pages 启用了 Pages

### 部署后检查
- [ ] 等待 1-3 分钟
- [ ] 在 `https://github.com/cuipointer/cuipointer.github.io` 看到新提交
- [ ] GitHub Settings → Pages 显示绿色勾号
- [ ] 访问 `https://cuipointer.github.io/` 能看到内容（可能需要硬刷新）

### 日常发布流程
```bash
# 1. 编写文章
./new_post.sh "文章标题"
# 编辑 source/_posts/文章标题.md

# 2. 本地预览
npm run server
# 访问 http://localhost:4000/ 验证效果

# 3. 提交源代码
git add .
git commit -m "Add: 新文章标题"
git push origin main

# 4. 构建与发布
npm run clean && npm run build && npm run deploy
# 或 ./deploy.sh

# 5. 等待并验证
# 等待 1-3 分钟，访问博客网址
```

---

**本文档更新于：** 2026-03-04  
**参考资料：**
- [Hexo 官方文档](https://hexo.io/docs/)
- [GitHub Pages 文档](https://pages.github.com/)
- [SSH 密钥配置指南](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
