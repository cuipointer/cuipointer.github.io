# 📚 Hexo 博客完整文档导航

> **最后更新：** 2026-03-05

---

## 快速入门

### 🚀 新用户必读
1. **[Hexo + GitHub Pages 完整部署教程](docs/guides/Hexo_GitHub_Pages_Deployment.md)** ⭐
   - 第一部分：环境部署及验证（Ubuntu）
   - 第二部分：输出第一篇博客及本地渲染
   - 第三部分：重要注意事项
   - 第四部分：原理解析
   - 第五部分：快捷脚本

### 👤 主题与外观
2. **[主题配置与自定义指南](docs/resources/Theme_Configuration_Guide.md)**
   - 颜色方案选择（当前：白色主题）
   - 导航菜单配置
   - 社交链接设置
   - 自定义颜色方案

---

## 快捷脚本使用

项目根目录下的 `scripts/` 文件夹提供以下快捷脚本：

```bash
# 环境检查
./scripts/check-env.sh          # 验证 Node.js, Git, SSH 等环境

# 文章管理
./scripts/new-post.sh "标题"    # 快速创建新文章

# 本地操作
./scripts/preview.sh            # 本地预览（包括清理、构建、启动服务）

# 部署发布
./scripts/deploy.sh             # 部署到 GitHub Pages（清理 + 构建 + 部署）
```

---

## 归档文档

早期部署过程中编写的参考文档（仍然有值）：

### [docs/archives/](docs/archives/)
- `GitHub_Pages_Setup_Guide.md` - GitHub Pages 快速配置指南
- `GitHub_Pages_Visual_Guide.md` - 修复过程的详细图文教程
- `Deployment_Pitfalls_Summary.md` - 部署过程中踩的 8 个坑（深度分析）
- `Complete_Hexo_Deployment_Guide.md` - 完整的从零到一教程
- `QUICKSTART.md` - 快速参考

---

## 目录结构

```
hexo-blog/
├── README.md                          # 这个导航文件
├── _config.yml                        # Hexo 主配置
├── _config.cactus.yml                 # 主题配置（颜色：white）
├── 
├── source/
│   ├── _posts/                        # 博客文章（Markdown）
│   └── about/
├── themes/
│   └── cactus/                        # Cactus 主题
├── public/                            # 生成的静态网站
│   └── index.html                     # 首页
├── 
├── docs/                              # 📚 所有文档
│   ├── guides/                        # 部署教程
│   │   └── Hexo_GitHub_Pages_Deployment.md  ⭐ 主教程
│   ├── resources/                     # 参考资源
│   │   └── Theme_Configuration_Guide.md     # 主题配置
│   └── archives/                      # 归档文档
│       ├── Deployment_Pitfalls_Summary.md
│       ├── Complete_Hexo_Deployment_Guide.md
│       └── ...
│
├── scripts/                           # 🛠️ 快捷脚本
│   ├── deploy.sh                      # 一键部署
│   ├── preview.sh                     # 本地预览
│   ├── new-post.sh                    # 创建文章
│   └── check-env.sh                   # 环境检查
│
└── package.json                       # Node.js 依赖
```

---

## 常用命令速查

```bash
# 📝 新建文章
./scripts/new-post.sh "My Article Title"

# 👀 本地预览（会启动 http://localhost:4000）
./scripts/preview.sh

# ✅ 环境检查
./scripts/check-env.sh

# 🚀 部署到 GitHub Pages
./scripts/deploy.sh

# 🧹 手动清理
npm run clean

# 🏗️ 手动构建
npm run build

# 🖥️ 手动启动本地服务
npm run server
```

---

## 工作流示例

### 发布一篇新文章

```bash
# 1. 创建文章
./scripts/new-post.sh "My First Post"

# 2. 编辑文章
nano source/_posts/my-first-post.md

# 3. 本地预览（验证效果）
./scripts/preview.sh
# 访问 http://localhost:4000/ 检查

# 4. 部署到线上
./scripts/deploy.sh

# 5. 等待 1-3 分钟，访问博客
# https://username.github.io/
```

---

## 配置速查

### 主要配置文件

| 文件 | 用途 |
|-----|------|
| `_config.yml` | Hexo 核心配置（标题、URL、部署地址等）|
| `_config.cactus.yml` | 主题配置（颜色、导航、社交链接等）|
| `.gitignore` | Git 忽略文件 |

### 关键配置项

**`_config.yml` 中：**
```yaml
title: My Blog                              # 博客标题
author: Your Name                           # 作者
url: https://username.github.io/            # 网址（替换 username）
root: /                                     # 根路径（用户页面用 /）

deploy:
  type: git
  repo: git@github.com:username/username.github.io.git  # GitHub Pages 仓库
  branch: main
```

**`_config.cactus.yml` 中：**
```yaml
colorscheme: white                          # 颜色方案（可选：white, light, dark, classic）
nav:
  home: /
  about: /about/
  articles: /archives/
```

---

## 常见问题

### 如何修改博客颜色？
编辑 `_config.cactus.yml`，修改 `colorscheme` 的值：
- `white` - 专业白色（推荐）
- `light` - 浅色
- `dark` - 深色
- `classic` - 经典

参考：[主题配置与自定义指南](docs/resources/Theme_Configuration_Guide.md)

### 博客无法显示？
1. 检查配置：`./scripts/check-env.sh`
2. 查看部署日志：运行 `./scripts/deploy.sh` 观察输出
3. 访问 GitHub Settings → Pages 确认已启用
4. 参考：[部署教程第三部分](docs/guides/Hexo_GitHub_Pages_Deployment.md#第三部分重要注意事项)

### 本地预览无法访问？
```bash
# 检查端口是否被占用
ss -ltnp | grep 4000

# 如果显示 LISTEN，说明服务正在运行
# 注意：可能需要 1-2 秒初始化
```

### 如何添加新的导航菜单项？
编辑 `_config.cactus.yml`：
```yaml
nav:
  home: /
  about: /about/
  articles: /archives/
  my-custom-page: /custom-page/  # 添加这一行
```

---

## 获取帮助

### 文档
- 📖 [Hexo 官方文档](https://hexo.io/docs/)
- 🎨 [Cactus 主题文档](https://github.com/probberechts/hexo-theme-cactus)
- 🌐 [GitHub Pages 文档](https://pages.github.com/)

### 本项目文档
- 🚀 [部署教程](docs/guides/Hexo_GitHub_Pages_Deployment.md)
- 🛠️ [故障排除](docs/archives/Deployment_Pitfalls_Summary.md)
- 🎨 [主题定制](docs/resources/Theme_Configuration_Guide.md)

---

## 状态检查

**当前配置：**
- ✅ 主题：Cactus
- ✅ 颜色方案：White（专业白色主题）
- ✅ 快捷脚本：4 个
- ✅ 文档：完整的 5 部分教程
- ✅ SSH 配置：已启用

**部署目标：**
- 📍 GitHub Pages 仓库：`https://github.com/username/username.github.io`
- 🌐 访问地址：`https://username.github.io/`
- 🔄 部署分支：`main`

---

**💡 提示：** 初次使用？从 [Hexo + GitHub Pages 完整部署教程](docs/guides/Hexo_GitHub_Pages_Deployment.md) 开始！
