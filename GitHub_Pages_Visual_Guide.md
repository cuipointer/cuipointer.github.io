# GitHub Pages 修复完全图文教程

## 问题诊断

你的博客 GitHub Pages 没有生效，原因是**两处配置错误**和**一处未启用设置**。

---

## 修复步骤详解

### 【第一步】修复部署仓库配置

**文件：** `_config.yml`  
**位置：** 文件底部的 `deploy:` 部分

#### ❌ 错误配置（修复前）
```yaml
deploy:
  type: git
  repo: git@github.com:cuipointer/cuihan.git        # ← 错误：指向源代码仓
  branch: gh-pages                                    # ← 错误：不支持的分支
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
```

**问题解释：**
- `repo` 指向的是 **源代码仓库** `cuihan.git`（存放 Hexo 源文件）
- 但我们需要推送到 **发布仓库** `cuipointer.github.io.git`（用户 GitHub Pages 仓库）
- `gh-pages` 分支是旧式配置，现在用户页面应该用 `main`

#### ✅ 正确配置（修复后）
```yaml
deploy:
  type: git
  repo: git@github.com:cuipointer/cuipointer.github.io.git  # ✓ 正确：用户 Pages 仓库
  branch: main                                                # ✓ 正确：用户页面用 main
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
```

---

### 【第二步】修复 URL 和根路径配置

**文件：** `_config.yml`  
**位置：** 文件上部的 `URL` 部分

#### ❌ 错误配置（修复前）
```yaml
# URL
url: https://cuipointer.github.io/cuihan      # ← 错误：多了 /cuihan/ 路径
root: /cuihan/                                 # ← 错误：子路径配置

# 这个配置适用于：https://username.github.io/project-name/ （项目页面）
```

**问题解释：**
- 你的 Pages 是 **用户页面**（`cuipointer.github.io`），不是项目页面
- 用户页面应该在根路径 `/` 下，不是子路径 `/cuihan/`
- 如果用错路径，生成的 HTML 中所有资源链接都会是 `/cuihan/...`，导致 404

#### ✅ 正确配置（修复后）
```yaml
# URL
url: https://cuipointer.github.io/             # ✓ 正确：根域名
root: /                                         # ✓ 正确：根路径

# 这个配置适用于：https://username.github.io/ （用户页面）
```

---

### 【第三步】重新构建并部署

执行以下命令重新生成静态文件并推送到 GitHub：

```bash
# 进入项目目录
cd /home/cuihan/cuihan

# 方法一：分步执行（便于观察）
npm run clean      # 清理旧的生成缓存
npm run build      # 生成新的静态文件（生成到 public/ 文件夹）
npm run deploy     # 部署到 GitHub（自动推送 public/ 到 cuipointer.github.io）

# 方法二：一键执行
./deploy.sh        # 等价于上面三行命令
```

**预期输出：**
```
INFO  Generated: 75 files in xxx ms
...
To github.com:cuipointer/cuipointer.github.io.git
 + abcd123...efgh456  HEAD -> main (forced update)
INFO  Deploy done: git
```

✅ **表示成功：** "Deploy done: git"

---

### 【第四步】推送源代码更改

配置文件改了，要保存到源代码仓库：

```bash
cd /home/cuihan/cuihan

# 1. 暂存修改
git add _config.yml

# 2. 提交
git commit -m "Fix: Update deploy config for GitHub Pages"

# 3. 推送到源代码仓库
git push origin main
```

---

### 【第五步】在 GitHub 网页端启用 Pages（最关键）

**⚠️ 用户必须手动完成此步骤**

#### 打开 Settings → Pages

1. 访问：[https://github.com/cuipointer/cuipointer.github.io/settings/pages](https://github.com/cuipointer/cuipointer.github.io/settings/pages)

2. 查看 **Build and deployment** 部分

3. **Source** 配置：
   - 选择：`Deploy from a branch`
   - 分支：`main`
   - 文件夹：`(root)`

4. 点击 **Save** 按钮

5. **等待 1-3 分钟**，GitHub 会自动部署

#### 检查部署状态

- 页面顶部会显示状态消息
- 绿色勾号 ✅ = 部署成功
- 黄色圆圈 ⏳ = 正在部署
- 红色叉号 ❌ = 部署失败

---

## 验证部署成功

### 访问你的博客

部署完成后，访问：
```
https://cuipointer.github.io/
```

你应该看到：
- 首页显示 "Cuihan's Blog"
- 文章列表可以加载
- CSS 样式正常显示
- 菜单链接可以点击

如果看到 "Site not found"，检查：
- [ ] GitHub Settings → Pages 已保存配置
- [ ] 等待足够的时间（可能需要 2-5 分钟）
- [ ] 尝试硬刷新（Ctrl+Shift+R）

---

## 关键配置对比表

| 配置项 | 用户页面（你的情况）| 项目页面（其他情况）|
|-------|------------------|------------------|
| **仓库名** | `username.github.io` | `project-name` |
| **Pages URL** | `https://username.github.io/` | `https://username.github.io/project-name/` |
| **_config.yml → url** | `https://cuipointer.github.io/` | `https://cuipointer.github.io/project-name/` |
| **_config.yml → root** | `/` | `/project-name/` |
| **deploy → branch** | `main` | `gh-pages` 或 `main` |
| **手动配置 Pages** | 需要（Settings → Pages） | 需要（Settings → Pages） |

---

## 完整仓库结构

```
cuihan 仓库（源代码）
└── main 分支
    ├── _config.yml           ← 部署配置指向 cuipointer.github.io
    ├── source/               ← 文章和页面源文件
    ├── themes/               ← 博客主题
    └── GitHub_Pages_Setup_Guide.md  ← 本文档

cuipointer.github.io 仓库（发布目标）
└── main 分支
    ├── index.html           ← 首页
    ├── about/
    ├── archives/
    ├── css/
    ├── js/
    └── ...（其他静态文件）
```

---

## 常见问题排查

### Q1: 部署成功但页面显示 404

**原因可能：**
- GitHub Pages 配置未启用或配置错误
- 等待时间不足（GitHub 需要 1-3 分钟部署）
- 浏览器缓存问题

**解决方案：**
1. 访问 https://github.com/cuipointer/cuipointer.github.io/settings/pages
2. 确认 Source 设置为 "Deploy from a branch" → main / (root)
3. 等待 3 分钟后，硬刷新浏览器（Ctrl+Shift+R）
4. 在浏览器开发者工具中清除 Site Data

### Q2: 页面显示但样式混乱（没有 CSS）

**原因可能：**
- `_config.yml` 中的 `root` 路径不正确
- CSS 链接生成时加了错误的前缀路径

**解决方案：**
- 检查 `root: /`（不是 `root: /cuihan/`）
- 重新执行 `npm run clean && npm run build && npm run deploy`

### Q3: SSH 推送失败（Permission denied）

**原因可能：**
- SSH 密钥未添加到 GitHub 账户
- SSH 密钥权限不足

**解决方案：**
```bash
# 测试 SSH 连接
ssh -T git@github.com

# 如果显示 Permission denied，则：
# 1. 访问 https://github.com/settings/keys
# 2. 添加 ~/.ssh/id_ed25519.pub 中的内容
# 3. 再次推送
```

---

## 成功标志清单

- [x] _config.yml deploy.repo 改为 `cuipointer.github.io.git`
- [x] _config.yml deploy.branch 改为 `main`
- [x] _config.yml url 改为 `https://cuipointer.github.io/`
- [x] _config.yml root 改为 `/`
- [x] npm run deploy 返回 "Deploy done: git"
- [x] GitHub Settings → Pages 已配置为 main / (root)
- [x] 等待 1-3 分钟
- [x] 访问 https://cuipointer.github.io/ 能看到博客

一旦全部✅，你的博客就成功上线了！

---

**修复完成时间：** 2026-03-04 23:40  
**参考文档：** [Hexo 官方部署文档](https://hexo.io/docs/one-command-deployment)
