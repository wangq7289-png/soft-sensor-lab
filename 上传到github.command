#!/bin/bash
# ============================================================
#  一键上传到 GitHub
#  双击运行，或在终端执行：bash 上传到github.command
#  也可以带说明：bash 上传到github.command "完成 A01"
# ============================================================
cd "$(dirname "$0")"

# ↓↓↓ 如果你的代理端口不是 7897，改这两行 ↓↓↓
export HTTPS_PROXY=http://127.0.0.1:7897
export HTTP_PROXY=http://127.0.0.1:7897
# ↑↑↑ 不需要代理就把上面两行删掉 ↑↑↑

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "❌ 还没配置 GitHub 远程仓库。"
  echo "   请先看《学习笔记/git与github.md》的第二、三步。"
  echo ""
  echo "按回车关闭..."; read; exit 1
fi

echo "=== 1/3 挑出改动 ==="
git add -A
git status -s

echo ""
echo "=== 2/3 存档 ==="
MSG="${1:-更新 $(date '+%Y-%m-%d %H:%M')}"
if git diff --cached --quiet; then
  echo "（没有新改动，跳过存档）"
else
  git commit -m "$MSG" && echo "已存档：$MSG"
fi

echo ""
echo "=== 3/3 上传 ==="
if git push; then
  echo ""
  echo "✅ 上传成功！去 https://github.com 看你的仓库吧。"
else
  echo ""
  echo "❌ 上传失败。请对照下面两条："
  echo "   1) 代理有没有开？（脚本里写的是 7897 端口，不对就改文件开头那两行）"
  echo "   2) GitHub 上那个仓库建了吗？如果提示 Repository not found，"
  echo "      就是还没建 —— 去 https://github.com/new 建一个叫 soft-sensor-lab 的 Public 空仓库。"
fi
echo ""
echo "按回车关闭..."; read
