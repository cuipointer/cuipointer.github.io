---
title: "Complete Guide: Build a Blog with Hexo + GitHub Pages"
date: 2026-03-05 01:12:00
lang: en
tags:
  - Hexo
  - GitHub Pages
  - Blog
  - Tutorial
categories:
  - Tech Tutorial
description: End-to-end guide for building and deploying a personal blog with Hexo, Cactus, and GitHub Pages.
---

## Overview

This guide shows a reliable workflow for building a personal blog using **Hexo + Cactus + GitHub Pages**.

## 1) Prepare environment

```bash
# install Node.js with nvm
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts

# verify
node -v
npm -v
```

## 2) Initialize Hexo project

```bash
mkdir my-blog && cd my-blog
npx hexo init .
npm install
```

## 3) Install and configure Cactus

```bash
cd themes
git clone https://github.com/probberechts/hexo-theme-cactus.git cactus
cd ..
cp themes/cactus/_config.yml _config.cactus.yml
```

In `_config.yml`:

```yaml
theme: cactus
url: https://yourname.github.io/
root: /
```

## 4) Configure deployment

```bash
npm install hexo-deployer-git --save
```

In `_config.yml`:

```yaml
deploy:
  type: git
  repo: git@github.com:yourname/yourname.github.io.git
  branch: main
```

## 5) Write and preview

```bash
npx hexo new "My first post"
npx hexo server
```

## 6) Build and deploy

```bash
npx hexo clean
npx hexo generate
npx hexo deploy
```

## Practical tips

- Keep source code in one branch/repo and static output in the pages branch/repo.
- Commit source changes before deployment.
- If deploy fails by SSH, verify your key with `ssh -T git@github.com`.

---

If this guide helps, feel free to star the project and share your setup.
