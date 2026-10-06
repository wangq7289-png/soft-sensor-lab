"""
练习模板 —— 新题就复制这个文件，改名成 A0X_xxx.py

跑法（在项目根目录）：
    .venv/bin/python 练习/A0X_xxx.py
"""
from pathlib import Path

import numpy as np
import pandas as pd
from sklearn.metrics import mean_squared_error, r2_score

# ===== 路径：不管从哪运行都能找到数据 =====
ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "repo/Soft_Sensor_Experiments/StackedAutoEncoder/Debutanizer_Column_Data.txt"


# ===== 1. 读数据 =====
df = pd.read_csv(DATA, sep=r"\s+")
print("数据形状：", df.shape)
print(df.head())
print()


# ===== 2. 打分函数（RMSE 越小越好，R² 越接近 1 越好）=====
def score(name, y_true, y_pred):
    y_true = np.asarray(y_true).reshape(-1)
    y_pred = np.asarray(y_pred).reshape(-1)
    rmse = np.sqrt(mean_squared_error(y_true, y_pred))
    r2 = r2_score(y_true, y_pred)
    print(f"{name:28s} RMSE = {rmse:.5f}   R² = {r2:.5f}")


# ===== 3. 你要做的事 =====
# 提示：时间序列不能用随机划分！要按时间顺序切片，例如：
#   train = 前 1000 行, test = 1600~2390 行

# TODO: 在这里写你的处理

# score("我的模型", y_true, y_pred)
