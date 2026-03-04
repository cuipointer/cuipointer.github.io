# Cuihan's Blog

基于 Hexo + GitHub Pages + Cactus 主题的个人博客。

## 🌐 访问地址

- **线上地址**：https://cuipointer.github.io/cuihan
- **GitHub 仓库**：https://github.com/cuipointer/cuihan

## 📋 项目信息

- **Hexo 版本**：8.x
- **主题**：Cactus
- **部署平台**：GitHub Pages
- **分支说明**：
  - `main` 分支：存储 Hexo 源码
  - `gh-pages` 分支：存储生成的静态网站（自动部署）

## 🚀 快速开始

### 1. 首次配置

#### 步骤 1：配置 SSH 密钥

如果还没有配置 SSH 密钥，请执行：

```bash
# 生成 SSH 密钥
ssh-keygen -t rsa -C "your@email.com"

# 查看公钥
cat ~/.ssh/id_rsa.pub
```

将公钥添加到 GitHub：
1. 访问 https://github.com/settings/keys
2. 点击 "New SSH key"
3. 粘贴公钥内容并保存

**当前生成的 SSH 公钥：**

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1pd9W/+laV1xfGVww8SnLa6TS+gS8MNufmkOE+vvEXfVncpnCVjLj/WoaKPMAWvjeSfg7Lqa19oUY0LnllIiMV5EGuyWpWiVE1mYUWhSjnke8wWJDPZ8M4I+X+AsAu2gu7ZTpdxi1FVtWAbAQudgF7K8V8iOkp66+qMDaqJDSfP8+PsiCayC94bzULdtCaL4/Jb+Z6s/42MFvRJ+rXHkceJX5t6Aq+V5YH5EMlGyWHdsIUIJPq2rI8f9GKBdU7+TS5JK1PgghEhQ3vOfH6NJxSpR286iPTLg32yn7riQebT4DVK6ktgjuQ197uMLuZQnUdN8HStjF6CvMqwz/QCNPSwpgiZWc6ir6KWhKMmqoTHzAxLkwzpKqYRf6zSYGDgTuLvLgMb84WKrsnGRocrF5nwXAQMd9A+Qjs3K4kXHV6MRHYF+FfAt5JLl+CLaKjbNwxP02SmHI3zxWlMLzTvejTJW8eF/s7sc0YFpdTZxPfTkcs0NujevPEuc9zL6dXr0= cuihan@blog
```

#### 步骤 2：推送源码到 GitHub

```bash
# 推送到 main 分支
git push -u origin main
```

#### 步骤 3：部署到 GitHub Pages

```bash
# 使用一键部署脚本
./deploy.sh

# 或手动执行
npm run clean
npm run build
npm run deploy
```

#### 步骤 4：配置 GitHub Pages

1. 访问仓库页面：https://github.com/cuipointer/cuihan
2. 进入 `Settings` -> `Pages`
3. 在 `Source` 中选择 `gh-pages` 分支
4. 点击 `Save` 保存

等待几分钟后，即可通过 https://cuipointer.github.io/cuihan 访问博客。

### 2. 本地预览

```bash
# 启动本地服务器
npm run server

# 访问地址
# http://localhost:4000/cuihan
```

**提示**：本地预览服务器已在后台运行，使用快捷键 `Ctrl+C` 停止。

### 3. 新建文章

**方式一：使用快捷脚本**

```bash
./new_post.sh "文章标题"
```

**方式二：使用 Hexo 命令**

```bash
npx hexo new "文章标题"
```

文章会自动创建在 `source/_posts/` 目录下。

### 4. 编辑文章

使用任意文本编辑器打开 Markdown 文件进行编辑。

文章头部（Front Matter）示例：

```markdown
---
title: 文章标题
date: 2026-03-04 10:00:00
tags:
  - 标签1
  - 标签2
categories:
  - 分类名称
description: 文章摘要描述
---

正文内容从这里开始...
```

### 5. 发布流程

#### 完整发布流程（推荐）

```bash
# 1. 提交源码到 GitHub
git add .
git commit -m "Add new post"
git push origin main

# 2. 部署到 GitHub Pages
./deploy.sh
```

#### 仅部署（不提交源码）

```bash
./deploy.sh
```

## 📦 项目结构

```
cuihan.space/
├── _config.yml              # Hexo 站点配置文件
├── _config.cactus.yml       # Cactus 主题配置文件
├── package.json             # Node.js 依赖配置
├── deploy.sh                # 一键部署脚本
├── new_post.sh              # 新建文章快捷脚本
├── setup_blog.sh            # 完整博客搭建脚本
├── README.md                # 本文件
├── docs_backup.md           # 完整教程备份
├── .gitignore               # Git 忽略文件
├── scaffolds/               # 文章模板
│   ├── draft.md
│   ├── page.md
│   └── post.md
├── source/                  # 源文件目录
│   ├── _posts/              # 博客文章
│   │   ├── hello-world.md
│   │   └── Hexo-GitHub-Pages-博客搭建完整教程.md
│   └── about/               # 关于页面
│       └── index.md
├── themes/                  # 主题目录
│   └── cactus/              # Cactus 主题
└── public/                  # 生成的静态文件（不提交到 Git）
```

## 🛠️ 常用命令

| 命令 | 说明 |
|------|------|
| `npm run clean` | 清理缓存 |
| `npm run build` | 生成静态文件 |
| `npm run server` | 启动本地服务器 |
| `npm run deploy` | 部署到 GitHub Pages |
| `./deploy.sh` | 一键部署（清理+构建+部署） |
| `./new_post.sh` | 快捷创建新文章 |
| `npx hexo new "title"` | 新建文章 |
| `npx hexo new page "name"` | 新建页面 |
| `npx hexo new draft "title"` | 新建草稿 |
| `npx hexo publish "title"` | 发布草稿 |

## 🎨 主题配置

主题配置文件：`_config.cactus.yml`

### 修改导航菜单

```yaml
nav:
  home: /
  about: /about/
  articles: /archives/
  projects: https://github.com/cuipointer
```

### 配置社交链接

```yaml
social_links:
  -
    icon: github
    link: https://github.com/cuipointer
```

更多主题配置请参考：https://github.com/probberechts/hexo-theme-cactus

## 🔧 常见问题

### 1. SSH 推送失败

**错误信息**：`Permission denied (publickey)`

**解决方法**：
```bash
# 测试 SSH 连接
ssh -T git@github.com

# 如果失败，检查 SSH 密钥是否已添加到 GitHub
cat ~/.ssh/id_rsa.pub
```

### 2. 部署后页面样式丢失

**原因**：`_config.yml` 中 URL 配置不正确

**解决方法**：
```yaml
url: https://cuipointer.github.io/cuihan
root: /cuihan/
```

### 3. GitHub Pages 404

**原因**：分支配置错误

**解决方法**：
1. 检查 GitHub 仓库 `Settings` -> `Pages`
2. 确认 `Source` 选择的是 `gh-pages` 分支
3. 确认 `hexo deploy` 已成功推送到 `gh-pages` 分支

### 4. 依赖安装失败

**解决方法**：
```bash
# 使用国内镜像源
npm config set registry https://registry.npmmirror.com

# 清除缓存
npm cache clean --force

# 重新安装
rm -rf node_modules package-lock.json
npm install
```

## 📚 学习资源

- **Hexo 官方文档**：https://hexo.io/zh-cn/docs/
- **Cactus 主题文档**：https://github.com/probberechts/hexo-theme-cactus
- **GitHub Pages 文档**：https://docs.github.com/en/pages
- **Markdown 语法**：https://markdown.com.cn/

## 📝 博客文章

### 已发布文章

1. **Hexo + GitHub Pages 博客搭建完整教程**
   - 位置：`source/_posts/Hexo-GitHub-Pages-博客搭建完整教程.md`
   - 内容：从零开始搭建 Hexo 博客的完整指南

2. **关于我 (About Me)**
   - 位置：`source/about/index.md`
   - 页面：https://cuipointer.github.io/cuihan/about/

### 写作技巧

1. **使用 Markdown 语法**编写文章
2. **添加标签和分类**方便归档
3. **使用代码高亮**展示代码片段
4. **插入图片**：放在 `source/images/` 目录

## 🤝 贡献指南

欢迎提交 Issue 或 Pull Request！

## 📄 许可证

MIT License

## 👤 作者

**Cuihan**

- GitHub: [@cuipointer](https://github.com/cuipointer)
- Blog: https://cuipointer.github.io/cuihan

---

**最后更新**：2026-03-04

*Keep Learning, Keep Coding!* 🚀
