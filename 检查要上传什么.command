#!/bin/bash
# ============================================================
#  上传前自检：看看这次会推上去什么
#  双击运行，或在终端执行：bash 检查要上传什么.command
# ============================================================
cd "$(dirname "$0")"
git config core.quotePath false

echo "==================================================="
echo "  上传前自检"
echo "==================================================="
echo

echo "【1】会被上传的文件："
git ls-files | sed 's/^/   /'
echo

echo "【2】还没存档的改动："
if [ -z "$(git status -s)" ]; then
  echo "   （干净）"
else
  git status -s | sed 's/^/   /'
fi
echo

echo "【3】历史里出现过的文件名："
git log --all --pretty=format: --name-only 2>/dev/null | sort -u | grep -v '^$' | sed 's/^/   /'
echo

echo "【4】常见敏感信息扫描："
hit=0
for pat in password passwd secret token api_key private_key 密码 身份证 手机号; do
  out=$(git grep -in "$pat" -- . 2>/dev/null | head -3)
  if [ -n "$out" ]; then
    hit=1
    echo "   ⚠️  命中 [$pat]："
    echo "$out" | sed 's/^/      /'
  fi
done
[ "$hit" = "0" ] && echo "   ✅ 没有发现常见敏感信息"
echo

echo "==================================================="
echo "  确认上面没有不该公开的内容，再执行 push"
echo "==================================================="
echo "按回车关闭..."
read
