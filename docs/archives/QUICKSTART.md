# 🚀 快速使用指南

## 当前状态

✅ 博客已初始化完成
✅ Cactus 主题已安装并配置
✅ GitHub Pages 部署已配置
✅ 已创建 2 篇示例文章
✅ 本地预览服务器正在运行

## 📍 本地预览地址

**http://localhost:4000/cuihan**

在浏览器中打开上述地址即可预览博客效果。

## 🔑 下一步操作

### 1. 配置 GitHub SSH 密钥（必须）

**已为你生成 SSH 密钥，请复制以下公钥添加到 GitHub：**

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1pd9W/+laV1xfGVww8SnLa6TS+gS8MNufmkOE+vvEXfVncpnCVjLj/WoaKPMAWvjeSfg7Lqa19oUY0LnllIiMV5EGuyWpWiVE1mYUWhSjnke8wWJDPZ8M4I+X+AsAu2gu7ZTpdxi1FVtWAbAQudgF7K8V8iOkp66+qMDaqJDSfP8+PsiCayC94bzULdtCaL4/Jb+Z6s/42MFvRJ+rXHkceJX5t6Aq+V5YH5EMlGyWHdsIUIJPq2rI8f9GKBdU7+TS5JK1PgghEhQ3vOfH6NJxSpR286iPTLg32yn7riQebT4DVK6ktgjuQ197uMLuZQnUdN8HStjF6CvMqwz/QCNPSwpgiZWc6ir6KWhKMmqoTHzAxLkwzpKqYRf6zSYGDgTuLvLgMb84WKrsnGRocrF5nwXAQMd9A+Qjs3K4kXHV6MRHYF+FfAt5JLl+CLaKjbNwxP02SmHI3zxWlMLzTvejTJW8eF/s7sc0YFpdTZxPfTkcs0NujevPEuc9zL6dXr0= cuihan@blog
```

**添加步骤：**
1. 访问：https://github.com/settings/keys
2. 点击 "New SSH key"
3. 将上面的公钥粘贴进去
4. 点击 "Add SSH key" 保存

### 2. 在 GitHub 创建仓库

1. 访问：https://github.com/new
2. 仓库名：`cuihan`
3. 设置为 Public
4. **不要**勾选 "Initialize with README"
5. 点击 "Create repository"

### 3. 推送源码到 GitHub

```bash
cd ~/cuihan.space
git push -u origin main
```

### 4. 部署到 GitHub Pages

```bash
cd ~/cuihan.space
./deploy.sh
```

### 5. 配置 GitHub Pages 服务

1. 访问仓库：https://github.com/cuipointer/cuihan
2. 进入 `Settings` -> `Pages`
3. 在 `Source` 下拉菜单选择 `gh-pages` 分支
4. 点击 `Save`

等待 2-5 分钟后，访问：**https://cuipointer.github.io/cuihan**

---

## ⚡ 常用命令速查

### 日常写作流程

```bash
# 1. 新建文章
./new_post.sh "文章标题"

# 2. 编辑文章（文件位于 source/_posts/）

# 3. 本地预览
npm run server
# 访问 http://localhost:4000/cuihan

# 4. 提交源码
git add .
git commit -m "Add new post"
git push

# 5. 部署发布
./deploy.sh
```

### 其他常用命令

```bash
# 清理缓存
npm run clean

# 生成静态文件
npm run build

# 仅部署（不重新构建）
npm run deploy

# 创建新页面
npx hexo new page "页面名"

# 创建草稿
npx hexo new draft "草稿标题"

# 发布草稿
npx hexo publish "草稿标题"
```

---

## 📂 项目文件说明

| 文件/目录 | 说明 |
|----------|------|
| `_config.yml` | Hexo 站点配置（URL、部署等） |
| `_config.cactus.yml` | Cactus 主题配置（导航、社交链接等） |
| `deploy.sh` | 一键部署脚本 |
| `new_post.sh` | 快捷新建文章 |
| `setup_blog.sh` | 完整自动化搭建脚本（从零开始） |
| `README.md` | 完整使用文档 |
| `docs_backup.md` | 详细搭建教程备份 |
| `source/_posts/` | 博客文章目录 |
| `source/about/` | 关于页面 |
| `themes/cactus/` | Cactus 主题 |
| `public/` | 生成的静态文件（构建后） |

---

## 🎯 已创建的文章

### 1. Hexo + GitHub Pages 博客搭建完整教程
- **文件**：`source/_posts/Hexo-GitHub-Pages-博客搭建完整教程.md`
- **标签**：Hexo, GitHub Pages, 博客搭建, 教程
- **分类**：技术教程
- **内容**：完整的 Hexo + GitHub Pages + Cactus 主题搭建指南

### 2. 关于我 (About)
- **文件**：`source/about/index.md`
- **类型**：独立页面
- **内容**：个人简介和博客说明

### 3. Hello World (默认文章)
- **文件**：`source/_posts/hello-world.md`
- **内容**：Hexo 默认的欢迎文章

---

## ⚠️ 重要提示

### 分支说明
- **main 分支**：存储 Hexo 源代码
- **gh-pages 分支**：存储生成的静态网站（自动创建）

### 工作流程
1. 在 `main` 分支进行写作和修改
2. 使用 `./deploy.sh` 部署时，会自动推送到 `gh-pages` 分支
3. GitHub Pages 从 `gh-pages` 分支读取网站内容

### 注意事项
- 每次修改文章后记得执行 `git push` 保存源码
- 执行 `./deploy.sh` 才会更新线上博客
- GitHub Pages 更新可能需要 2-5 分钟

---

## 📚 更多帮助

- **完整文档**：查看项目根目录的 `README.md`
- **详细教程**：查看 `docs_backup.md` 或博客文章
- **Hexo 官方文档**：https://hexo.io/zh-cn/docs/
- **Cactus 主题**：https://github.com/probberechts/hexo-theme-cactus

---

**项目路径**：`~/cuihan.space`
**GitHub 仓库**：`git@github.com:cuipointer/cuihan.git`
**线上地址**：`https://cuipointer.github.io/cuihan`（配置后可访问）

---

*Happy Blogging! 🎉*
