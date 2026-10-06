# A01 · 给 SAEV0.2.py 加 RMSE / R² 输出

> 目标：让 `StackedAutoEncoder/SAEV0.2.py` 跑完后，**打印出 RMSE 和 R²**，而不是只画图不出数。
> 这正好是老师说的"学会如何修改代码"的第一课。

---

## 为什么这个任务值得做

仓库里的脚本最后只 `plt.plot(...)`，**不打印任何指标**。所以"跑通了"到底准不准，你根本不知道。加上指标输出，你才真正拥有"复现数字"的能力。

---

## 具体怎么改（3 步）

### 第 1 步：找到文件

```
repo/Soft_Sensor_Experiments/StackedAutoEncoder/SAEV0.2.py
```

用 VS Code 或任意编辑器打开。

### 第 2 步：翻到最后一行

文件结尾是这样的（第 294–298 行）：

```python
plt.plot(pred.cpu().detach().numpy(), label='Prediction')
plt.plot(test_y, label='Actual')
plt.xlabel('Number of records')
plt.ylabel('y value')
plt.legend()
```

### 第 3 步：在最后一行 `plt.legend()` 之后，追加这几行

```python
# ===== 我自己加的：打印测试集 RMSE / R² =====
from sklearn.metrics import mean_squared_error, r2_score
y_pred = pred.cpu().detach().numpy().reshape(-1)
y_true = test_y.reshape(-1)
rmse = np.sqrt(mean_squared_error(y_true, y_pred))
r2 = r2_score(y_true, y_pred)
print(f"测试集 RMSE = {rmse:.5f}")
print(f"测试集 R² = {r2:.5f}")
plt.savefig('SAE_result.png', dpi=120) # 顺便存一张图，以后写周报用
plt.show() # 弹出图窗口
```

保存文件，重新跑：

```bash
cd ~/Desktop/softsensor/repo/Soft_Sensor_Experiments
/Users/tuanzichu/Desktop/softsensor/.venv/bin/python StackedAutoEncoder/SAEV0.2.py
```

---

## 每一行在干什么（通俗版）

| 代码 | 人话 |
|---|---|
| `from sklearn.metrics import ...` | 从工具库里借来"打分"用的尺子 |
| `y_pred = pred...numpy()` | 把模型预测结果转成普通数组 |
| `y_true = test_y.reshape(-1)` | 把真实答案也转成一列 |
| `rmse = np.sqrt(mean_squared_error(...))` | 算误差：越小越准 |
| `r2 = r2_score(...)` | 算 R²：越接近 1 越好 |
| `print(f"测试集 RMSE = {rmse:.5f}")` | 打印结果，保留 5 位小数 |
| `plt.savefig(...)` | 把图存成文件，方便发老师 |
| `plt.show()` | 弹出图窗口 |

---

## 验收标准

- 跑完能看到终端打印出 `测试集 RMSE = 0.0xxxx` 和 `测试集 R² = 0.9xxxx` 两行。
- 同目录多出一个 `SAE_result.png`。

**跑出来的数字，记在这篇下面的「我的结果」里，然后 git commit 一下。**

---

## 预期结果参考

README 里 StackedAutoEncoder（半监督预训练）没有直接给数字，但同一数据下：
- `GSTAE` 的 GS-TAE 是 RMSE 0.0299 / R² 0.9704
- `SLSTM` 是 RMSE 0.0415 / R² 0.9525

你复现的 SAE 数字应该在**同一个数量级**。如果差很多（比如 R² 只有 0.5），说明有问题——**这时候先别慌，把数字和报错发我**，我们一起查。
