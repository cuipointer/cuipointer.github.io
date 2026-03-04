# 主题配置与自定义指南

## 当前主题配置

当前博客使用 **Cactus 主题**，配置文件：`_config.cactus.yml`

### 颜色方案选择

**当前方案：** `white`（推荐用于专业博客）

#### 可选颜色方案

```yaml
colorscheme: white      # ⭐ 当前选择 - 专业白色主题
colorscheme: light      # 浅色主题（灰色背景）
colorscheme: classic    # 经典主题（带重音色）
colorscheme: dark       # 深色主题（黑色背景）
```

**效果预览：**

| 方案 | 背景色 | 文字色 | 适用场景 |
|-----|-------|--------|--------|
| **white** | 白色 | 黑色 | 专业博客、白天阅读 ⭐ |
| light | 浅灰 | 黑色 | 柔和主题 |
| classic | 白色 | 黑色+重音 | 文艺风格 |
| dark | 深灰/黑 | 白色 | 夜间阅读、现代风 |

### 如何切换颜色方案

**方法：** 编辑 `_config.cactus.yml`

```yaml
# 找到这一行
colorscheme: white

# 改成你想要的方案
colorscheme: dark       # 或 light, classic 等
```

然后重新构建：
```bash
./scripts/preview.sh    # 本地预览
./scripts/deploy.sh     # 推送到线上
```

---

## 自定义颜色方案

### 创建自定义颜色

如果需要自定义颜色，在 `themes/cactus/source/css/_colors/` 目录下创建新文件。

**例：创建 `my-custom.styl` 文件**

```stylus
// 自定义配色方案
// 文件名：themes/cactus/source/css/_colors/my-custom.styl

// 定义颜色变量
$color-primary = #3498db       // 主色调
$color-background = #f5f5f5    // 背景色
$color-text = #333333          // 文字色
$color-border = #e0e0e0        // 边框色
$color-link = #2980b9          // 链接色

// 应用颜色
body
  background-color $color-background
  color $color-text

a
  color $color-link
  &:hover
    color darken($color-link, 10%)

.header
  border-bottom 1px solid $color-border
```

然后在 `_config.cactus.yml` 中使用：
```yaml
colorscheme: my-custom
```

---

## 常用配置项

### 导航菜单

编辑 `_config.cactus.yml`：

```yaml
nav:
  home: /                              # 首页
  about: /about/                       # 关于页面
  articles: /archives/                 # 文章归档
  projects: https://github.com/你的用户名  # 项目链接（外链）
```

### 社交链接

```yaml
social_links:
  -
    icon: github
    link: https://github.com/你的用户名
    label: GitHub
  -
    icon: twitter
    link: https://twitter.com/你的用户名
  -
    icon: linkedin
    link: https://linkedin.com/in/你的用户名
  -
    icon: envelope
    link: mailto:你的邮箱@example.com
```

**可用图标：** Font Awesome 图标名称  
参考：https://fontawesome.com/icons

### Logo 配置

```yaml
logo:
  enabled: true           # 是否显示 logo
  width: 50              # 宽度（像素）
  height: 50             # 高度（像素）
  url: /images/logo.png  # logo 图片路径
  gravatar: false        # 是否使用 Gravatar 头像
  grayout: true          # 鼠标悬停时灰度效果
```

---

## 主页设置

### 显示最新文章

```yaml
posts_overview:
  show_all_posts: false   # 不显示所有文章
  post_count: 5          # 首页显示最新 5 篇
  sort_updated: false    # 按创建日期排序
```

### 标签云

```yaml
tags_overview: false     # 首页不显示标签云
```

### 归档设置

```yaml
archive:
  sort_updated: false    # 按创建日期排序
```

---

## 代码高亮配置

### 高亮主题

```yaml
# 注意：Cactus 不使用 hexo 的 highlight 配置
# 代码高亮由 css/_highlight/ 下的样式表控制
```

查看可用的高亮主题：
```bash
ls themes/cactus/source/css/_highlight/
```

### 使用特定高亮主题

如需修改，编辑 `themes/cactus/source/css/style.styl` 中的导入语句。

---

## 性能优化

### 使用 CDN

```yaml
cdn:
  enable: true          # 启用 CDN 加速
  jquery: https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js
  clipboard: https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.7/clipboard.min.js
  font_awesome: https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css
```

### 禁用不需要的功能

```yaml
# 如果不需要评论，禁用 Disqus
disqus:
  enabled: false

# 如果不需要分析，禁用 Google Analytics
google_analytics:
  enabled: false
```

---

## 常见问题

### Q1：切换颜色后看不到效果？
**A：** 执行清理和重新构建：
```bash
npm run clean && npm run build && ./scripts/preview.sh
```

### Q2：如何自定义字体？
**A：** 修改 `themes/cactus/source/css/_fonts.styl` 文件，更改 `@font-face` 定义。

### Q3：如何修改页面宽度？
**A：** 编辑 `_config.cactus.yml`：
```yaml
page_width: 48  # 当前值（rem 单位），可改为 60, 72 等
```

### Q4：如何添加自己的 CSS？
**A：** 在 `themes/cactus/source/css/_extend.styl` 中添加自定义样式。

---

## 更多资源

- **主题官方文档：** https://github.com/probberechts/hexo-theme-cactus
- **Hexo 配置文档：** https://hexo.io/docs/configuration.html
- **Stylus 语言：** https://stylus-lang.com/

---

**提示：** 修改主题配置后，请先本地预览再推送到线上！
