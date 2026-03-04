# Cactus 主题中英文互换技术方案与部署教程

## 1. 目标

在 Hexo + Cactus 博客中实现：

- 中文与英文两套内容并存
- 顶部一键中英文互换
- 英文站点导航自动指向 `/en/*`
- 保留现有白/暗主题切换功能

## 2. 技术方案（本项目采用）

### 2.1 语言路由策略

- `zh-CN` 作为默认语言：中文内容在根路径，如 `/about/`
- `en` 作为第二语言：英文内容在 `/en/` 前缀下，如 `/en/about/`

配置点：

- 根配置 `_config.yml`
  - `language: [zh-CN, en]`
  - `i18n_dir: :lang`

### 2.2 内容组织策略

- 中文内容保留在原路径：
  - `source/about/index.md`
  - `source/_posts/*.md`
- 英文内容新增到英文路径：
  - `source/en/index.md`
  - `source/en/about/index.md`
  - `source/en/archives/index.md`
  - `source/_posts/en/*.md`（`lang: en`）

### 2.3 语言切换实现

在主题头部模板 `themes/cactus/layout/_partial/header.ejs` 中：

1. 识别当前路径是否为英文（`/en/...`）
2. 生成同路径的目标语言链接
3. 顶部导航增加语言切换入口
4. 在英文状态下，为站内导航自动添加 `/en` 前缀

### 2.4 样式与主题切换兼容

- 保留已有明暗主题逻辑（`theme-style` + `localStorage`）
- 语言切换仅影响路由，不影响颜色主题切换

## 3. 实施步骤

### 步骤 1：改站点语言配置

编辑 `_config.yml`：

```yaml
language:
  - zh-CN
  - en
i18n_dir: :lang
```

### 步骤 2：新增英文内容

创建：

- `source/en/index.md`
- `source/en/about/index.md`
- `source/en/archives/index.md`
- `source/_posts/en/hexo-github-pages-complete-guide.md`

并在英文文章 Front Matter 中设置：

```yaml
lang: en
```

### 步骤 3：改导航语言切换

编辑：

- `themes/cactus/layout/_partial/header.ejs`

新增逻辑：

- `中文` ↔ `English` 切换链接
- 英文态下自动将 `/about/` 变为 `/en/about/` 等

### 步骤 4：构建与本地预览

> 若将 `language` 改为数组后构建报错，需要兼容主题模板 `themes/cactus/layout/layout.ejs`，使其同时支持字符串与数组语言配置。

```bash
npm run clean
npm run build
npx hexo server -p 4000
```

访问：

- 中文首页：`http://localhost:4000/`
- 英文首页：`http://localhost:4000/en/`

### 步骤 5：部署到 GitHub Pages

```bash
npm run deploy
```

## 4. 验证清单

- [ ] `/` 页面显示语言切换入口 `English`
- [ ] `/en/` 页面显示语言切换入口 `中文`
- [ ] 英文态导航可进入 `/en/about/`、`/en/archives/`
- [ ] 明暗主题切换仍可用
- [ ] 部署后线上可访问 `/en/`

## 5. 常见问题

### Q1：切换到英文后出现 404？

说明该路径没有英文内容。需补充对应英文页面或文章。

### Q2：英文导航跳回中文页？

检查 `header.ejs` 是否已在英文态给站内链接加 `/en` 前缀。

### Q3：部署后没变化？

先执行：

```bash
npm run clean && npm run build && npm run deploy
```

并等待 GitHub Pages 缓存刷新（通常 1~5 分钟）。

## 6. 本项目改动文件清单

- `_config.yml`
- `themes/cactus/layout/layout.ejs`
- `themes/cactus/layout/_partial/header.ejs`
- `themes/cactus/source/css/_partial/header.styl`
- `source/en/index.md`
- `source/en/about/index.md`
- `source/en/archives/index.md`
- `source/_posts/en/hexo-github-pages-complete-guide.md`

（保留）

- `themes/cactus/layout/_partial/head.ejs`
- `themes/cactus/source/js/main.js`

---

如需升级到“文章一对一中英版本自动关联跳转”（根据 slug 精准映射），可在此方案上增加文章映射表或统一 slug 规范。