#!/bin/bash
# ============================================================
#  软测量项目环境 一键安装脚本
#  双击运行，或在「终端」里执行：bash install_env.command
#  需要联网（建议保持你的代理开启，或正常国内网络）
# ============================================================
cd "$(dirname "$0")"

# 国内镜像源（快且稳）；如果你代理开着想走官方源，把下面这行改成 https://pypi.org/simple/
PYPI="https://mirrors.aliyun.com/pypi/simple/"

echo "================================================"
echo "  软测量项目环境安装（约几分钟，请耐心等待）"
echo "================================================"

echo "[1/4] 创建 Python 虚拟环境 .venv ..."
python3 -m venv .venv

echo "[2/4] 升级 pip ..."
.venv/bin/pip install --quiet --upgrade pip -i "$PYPI"

echo "[3/4] 安装依赖（numpy/pandas/scipy/sklearn/matplotlib/torch/torchvision）"
echo "      其中 torch 较大（约 150MB），进度慢一点是正常的..."

PKGS="numpy pandas scipy scikit-learn matplotlib torch torchvision"

# 先走国内阿里云源；失败则自动改用官方源重试
if ! .venv/bin/pip install -i "$PYPI" $PKGS; then
  echo ""
  echo "⚠️  阿里云源安装失败，自动改用 PyPI 官方源重试（若你开着代理会更快）..."
  .venv/bin/pip install -i https://pypi.org/simple/ $PKGS
fi

echo "[4/4] 验证安装 ..."
.venv/bin/python - <<'PY'
import sys, numpy, pandas, scipy, sklearn, matplotlib, torch, torchvision
print("")
print("✅ 环境安装成功！版本如下：")
print("   Python       ", sys.version.split()[0])
print("   numpy        ", numpy.__version__)
print("   pandas       ", pandas.__version__)
print("   scipy        ", scipy.__version__)
print("   scikit-learn ", sklearn.__version__)
print("   matplotlib   ", matplotlib.__version__)
print("   torch        ", torch.__version__)
print("   torchvision  ", torchvision.__version__)
print("   CUDA 可用    ", torch.cuda.is_available(), "（Mac 上是 False，属正常，走 CPU）")
PY

echo ""
echo "================================================"
echo "  全部完成！现在可以运行项目脚本了。"
echo "  具体怎么跑，看同目录下的《运行指南.md》"
echo "================================================"
echo "按回车键关闭窗口..."
read
