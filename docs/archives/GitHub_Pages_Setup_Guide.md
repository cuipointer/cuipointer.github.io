## 修复进度总结

### ✅ 已完成的步骤

- [x] **修复部署仓库配置**
  ```yaml
  # _config.yml 中的 deploy 部分
  deploy:
    type: git
    repo: git@github.com:cuipointer/cuipointer.github.io.git
    branch: main
  ```

- [x] **修复 URL 路径配置**
  ```yaml
  # _config.yml 中的 URL 部分
  url: https://cuipointer.github.io/
  root: /
  ```

- [x] **完整构建与部署**
  ```bash
  npm run clean && npm run build && npm run deploy
  # ✓ 75 文件生成成功
  # ✓ 推送到 cuipointer.github.io 成功
  ```

- [x] **源代码推送**
  ```bash
  git push origin main  # 推送到 cuihan 仓库
  ```

### 🔄 正在进行的步骤（你需要手动完成）

- [ ] **在 GitHub 网页端启用 Pages**（见上章第四步）

---



## 问题诊断与修复

### 原问题
GitHub Pages 未生效，博客无法通过 `https://cuipointer.github.io/` 访问。

### 根本原因
Hexo 部署配置（`_config.yml`）中的 `deploy.repo` 指向错误的仓库：
```yaml
# ❌ 错误配置
deploy:
  type: git
  repo: git@github.com:cuipointer/cuihan.git
  branch: gh-pages
```

## 修复方案

## 第四步：GitHub Pages 网页配置（必须做）

### 📌 重要：在 GitHub 网页端启用 Pages

即使已推送静态文件，仍需在 GitHub 仓库设置中手动启用 Pages：

1. **打开仓库设置**
   - 访问：https://github.com/cuipointer/cuipointer.github.io/settings
   - 如果无权限，确认是否为仓库所有者

2. **配置 GitHub Pages**
   - 左侧菜单 → `Pages`
   - **Build and deployment** 部分：
     - **Source** = `Deploy from a branch`
     - **Branch** = `main` → `(root)` 
     - 点击 `Save`

3. **检查部署状态**
   - 页面顶部会显示部署进度
   - 绿色勾号 ✅ = 部署成功
   - 可能需要等待 1-3 分钟

4. **验证访问**  
   ```
   https://cuipointer.github.io/
   ```
   
### 常见问题排查

| 症状 | 原因 | 解决方案 |
|------|------|--------|
| 显示 404 Not Found | Pages 未启用或配置错误 | 检查 Settings → Pages 配置 |
| 显示 "Site not found" | 仓库未设置为公开，或无 source 分支 | 设置仓库为 Public，确保 main 分支存在并有文件 |
| 部署中（进度条） | GitHub 正在生成静态页面 | 等待 2-5 分钟后刷新 |
| CNAME 错误 | 自定义域名配置冲突 | 清空 CNAME 文件或正确配置域名 |



编辑 `_config.yml`，找到 `deploy` 部分：

```yaml
# ✅ 正确配置
deploy:
  type: git
  repo: git@github.com:cuipointer/cuipointer.github.io.git
  branch: main
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
```

**关键点解释：**
| 配置项 | 值 | 说明 |
|------|-----|-----|
| **repo** | `git@github.com:cuipointer/cuipointer.github.io.git` | 用户页面仓库（用户名.github.io） |
| **branch** | `main` | 用户页面默认从 main 分支拉取，不用 gh-pages |
| **type** | `git` | 使用 Git 直接推送部署 |

### 第二步：重新部署

执行完整的清理、构建、部署流程：

```bash
# 进入项目目录
cd /home/cuihan/cuihan

# 设置 Node 环境（如果使用 nvm）
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# 执行部署
npm run clean     # 清理缓存
npm run build     # 构建静态文件
npm run deploy    # 部署到 GitHub
```

**预期输出：**
```
INFO  Deploying: git
INFO  Clearing .deploy_git folder...
INFO  Copying files from public folder...
...
To github.com:cuipointer/cuipointer.github.io.git
 + e3fa785...503476f HEAD -> main (forced update)
INFO  Deploy done: git
```

### 第三步：推送源代码更改

```bash
cd /home/cuihan/cuihan

# 提交配置文件修改
git add _config.yml
git commit -m "Fix: Update deploy config to use cuipointer.github.io repo"

# 推送到源代码仓库
git push origin main
```

## 仓库结构说明

本项目使用**两个 GitHub 仓库**：

### 1️⃣ 源代码仓库：`cuihan`
```
https://github.com/cuipointer/cuihan
├── main  ← 存储 Hexo 源文件、配置、文章等
└── 分支：main
```

**推送命令：**
```bash
git push origin main
```

### 2️⃣ 发布仓库：`cuipointer.github.io`
```
https://github.com/cuipointer/cuipointer.github.io
├── main  ← GitHub Pages 生成的静态文件
└── 分支：main（GitHub 自动从此分支生成页面）
```

**部署方式：** Hexo 自动推送，无需手动操作

## 验证 GitHub Pages 是否生效

### 方法一：访问网址
```
https://cuipointer.github.io/
```

### 方法二：检查 GitHub 设置
1. 访问 https://github.com/cuipointer/cuipointer.github.io
2. 进入 `Settings` → `Pages`
3. 验证 `Build and deployment` 中：
   - **Source** = `Deploy from a branch`
   - **Branch** = `main` (root folder)

## 完整工作流程

### 默认工作流（推荐）

```bash
# 1. 编写新文章
./new_post.sh "文章标题"
# 编辑 source/_posts/文章标题.md

# 2. 提交源代码
git add .
git commit -m "Add new post: 文章标题"
git push origin main

# 3. 构建并部署到 GitHub Pages
npm run clean && npm run build && npm run deploy
```

### 快捷方式（一键部署）

```bash
./deploy.sh
```

这个脚本会执行：
```bash
#!/bin/bash
npm run clean
npm run build
npm run deploy
```

## 小贴士

✅ **务必做的事：**
- [ ] 确保 SSH 密钥已添加到 GitHub 账户
- [ ] 本地测试：`npm run server` → 访问 `http://localhost:4000/`
- [ ] 验证部署配置指向正确的仓库

❌ **常见错误：**
- 部署分支错误（用 gh-pages 而非 main）
- 仓库地址混淆（混淆了源码仓和发布仓）
- SSH 密钥未授权（Permission denied）

---

**配置完成时间：** 2026-03-04  
**博客地址：** https://cuipointer.github.io/  
**源代码：** https://github.com/cuipointer/cuihan  
**发布仓库：** https://github.com/cuipointer/cuipointer.github.io
