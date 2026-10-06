#!/bin/bash
# ============================================================
#  一键上传到 GitHub
#  双击运行，或在终端执行：bash 上传到github.command
#  也可以带说明：bash 上传到github.command "完成 A01"
# ============================================================
cd "$(dirname "$0")"

# ↓↓↓ 如果你的代理端口不是 7897，改这里 ↓↓↓
PROXY="http://127.0.0.1:7897"
# ↑↑↑ 不需要代理就把 PROXY 设为空字符串：PROXY="" ↑↑↑

echo "==================================================="
echo "  上传到 GitHub"
echo "==================================================="
echo

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "❌ 还没配置 GitHub 远程仓库。"
  echo "   请先看《学习笔记/git与github.md》的第二步。"
  echo ""
  echo "按回车关闭..."; read; exit 1
fi

echo "远程仓库：$(git remote get-url origin)"
echo

echo "=== 1/3 挑出改动 ==="
git add -A
if [ -z "$(git status -s)" ]; then echo "（没有改动）"; else git status -s; fi
echo

echo "=== 2/3 存档 ==="
MSG="${1:-更新 $(date '+%Y-%m-%d %H:%M')}"
if git diff --cached --quiet; then
  echo "（没有新改动，跳过存档）"
else
  git commit -m "$MSG" && echo "已存档：$MSG"
fi
echo

# ---- 上传：先带代理试，不行再直连试 ----
push_once() {
  git push -u origin main 2>&1 | tail -8
  return "${PIPESTATUS[0]}"
}

OK=""
echo "=== 3/3 上传 ==="
if [ -n "$PROXY" ]; then
  export HTTPS_PROXY="$PROXY" HTTP_PROXY="$PROXY"
  echo "（走代理 $PROXY）"
  if push_once; then OK=1; fi
  if [ -z "$OK" ]; then
    echo ""
    echo "⚠️  带代理没成功，改成直连再试一次..."
    unset HTTPS_PROXY HTTP_PROXY
    if push_once; then OK=1; fi
  fi
else
  if push_once; then OK=1; fi
fi

echo ""
if [ -n "$OK" ]; then
  echo "==================================================="
  echo "  ✅ 上传成功！"
  echo "  $(git remote get-url origin | sed 's/\.git$//')"
  echo "==================================================="
else
  echo "==================================================="
  echo "  ❌ 上传失败，最常见的原因："
  echo "  1) 需要登录：会提示 Username / Password ——"
  echo "     Username 填 wangq7289-png，Password 粘贴 Token（不是账号密码）"
  echo "  2) 代理没开：改本文件开头的 PROXY 端口，或设为空字符串走直连"
  echo "  3) 仓库还没建：去 https://github.com/new 建 soft-sensor-lab"
  echo "==================================================="
fi
echo ""
echo "按回车关闭..."; read
