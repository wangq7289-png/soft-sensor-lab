"""
Debutanizer 软测量 baseline —— 纯 numpy，零依赖，保证能跑。

目的：
  1) 复刻仓库 SAEV0.2.py 的数据构造，先拿到"线性模型"的参照数字
  2) 验证一个关键疑点：把 y 的历史值当输入，到底贡献了多少性能

跑法：
  python3 baseline_debutanizer.py
"""
import numpy as np

DATA = 'StackedAutoEncoder/Debutanizer_Column_Data.txt'

# ---------- 1. 读数据 ----------
d = np.loadtxt(DATA, skiprows=1)          # 2394 x 8
x_temp = d[:, :7]                         # 7 个输入
y_temp = d[:, 7]                          # 输出 y

# ---------- 2. 完全复刻 SAEV0.2.py 的 13 维特征构造 ----------
N = 2390
x_new = np.zeros((N, 13))
x_6 = x_temp[:, 4]                        # 第5个输入 u5
x_9 = (x_temp[:, 5] + x_temp[:, 6]) / 2   # (u6+u7)/2
x_new[:, 0:5] = x_temp[4:2394, 0:5]
x_new[:, 5]   = x_6[3:2393]
x_new[:, 6]   = x_6[2:2392]
x_new[:, 7]   = x_6[1:2391]
x_new[:, 8]   = x_9[4:2394]
x_new[:, 9]   = y_temp[3:2393]            # y(t-1)
x_new[:, 10]  = y_temp[2:2392]            # y(t-2)
x_new[:, 11]  = y_temp[1:2391]            # y(t-3)
x_new[:, 12]  = y_temp[0:2390]            # y(t-4)
y_new = y_temp[4:2394]                    # 预测目标 y(t)

# ---------- 3. 完全复刻仓库的 train/val/test 划分 ----------
train_x, train_y = x_new[:1000],    y_new[:1000]
val_x,   val_y   = x_new[1000:1600], y_new[1000:1600]
test_x,  test_y  = x_new[1600:2390], y_new[1600:2390]

def r2(y, yhat):
    ss = np.sum((y - yhat) ** 2)
    st = np.sum((y - np.mean(y)) ** 2)
    return 1 - ss / st

def rmse(y, yhat):
    return float(np.sqrt(np.mean((y - yhat) ** 2)))

def fit_linear(X, y):
    A = np.hstack([X, np.ones((X.shape[0], 1))])
    w, *_ = np.linalg.lstsq(A, y, rcond=None)
    return lambda Xt: np.hstack([Xt, np.ones((Xt.shape[0], 1))]) @ w

def fit_ridge(X, y, lam=1e-3):
    A = np.hstack([X, np.ones((X.shape[0], 1))])
    nfeat = A.shape[1]
    w = np.linalg.solve(A.T @ A + lam * np.eye(nfeat), A.T @ y)
    return lambda Xt: np.hstack([Xt, np.ones((Xt.shape[0], 1))]) @ w

# ---------- 4. 三个特征集，回答"性能来自哪里" ----------
sets = {
    'A: 只用 u@t (7维, 纯静态)':   x_new[:, 0:5],                          # 其实 u1..u5 共5维? 看下面修正
    'B: u 特征+滞后 (9维, 无 y)':    x_new[:, 0:9],
    'C: 仓库原版 (13维, 含 y 滞后)': x_new,
}

# 修正 A：纯静态 = 7 个原始输入在 t 时刻
A_x = x_temp[4:2394, :]                 # u1..u7 @ t
sets['A: 只用 u@t (7维, 纯静态)'] = A_x

print("=" * 70)
print("Debutanizer 软测量 baseline（线性模型 + 岭回归 + 朴素持续性）")
print("=" * 70)

for name, Xfull in sets.items():
    trX, vaX, teX = Xfull[:1000], Xfull[1000:1600], Xfull[1600:2390]
    for mname, fitter in [('线性回归', fit_linear), ('岭回归  ', fit_ridge)]:
        pred = fitter(trX, train_y)
        rm, rr = rmse(test_y, pred(teX)), r2(test_y, pred(teX))
        print(f"{name:38s} | {mname} | 测试RMSE={rm:8.5f}  R²={rr:7.4f}")

# 持续性基准：y_hat(t) = y(t-1)
print("-" * 70)
persist = y_new[1599:2389]              # test_y[t] 对应 y_new[t]，其 t-1 是 y_new[1599:2389]
print(f"{'朴素持续性 y(t)=y(t-1)':38s} | 基线     | 测试RMSE={rmse(test_y, persist):8.5f}  R²={r2(test_y, persist):7.4f}")

print()
print("结论提示：")
print("  · 比较 A 行 和 C 行：性能差基本就是『y 的历史滞后』贡献的")
print("  · 如果 C 和『持续性』差不多 → 说明模型没学到多少真正的输入-输出关系")
