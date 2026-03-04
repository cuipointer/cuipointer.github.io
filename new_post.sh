#!/usr/bin/env bash
# 新建文章快捷脚本
set -euo pipefail

# 加载 Node.js 环境
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  . "$NVM_DIR/nvm.sh"
  nvm use --lts >/dev/null 2>&1
fi

cd "$(dirname "$0")"

if [[ $# -eq 0 ]]; then
  read -p "📝 请输入文章标题: " title
else
  title="$1"
fi

npx hexo new "$title"
echo ""
echo "✅ 文章已创建完成！"
echo "📄 文件路径：source/_posts/$title.md"
echo ""
echo "💡 提示："
echo "  - 编辑文章后运行 'npm run server' 进行本地预览"
echo "  - 预览地址：http://localhost:4000/cuihan"
