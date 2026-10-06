# Git 和 GitHub：从本地到上传（手把手）

你有 GitHub 账号，这篇教你把本地这个文件夹推上去，以及之后每天怎么用。

---

## 零、先理解三个词（30 秒）

| 词 | 人话 |
|---|---|
| **git** | 装在你电脑上的"存档工具"，记录每一次改动 |
| **GitHub** | 网上的仓库，用来放你存档的东西 |
| **commit** | 一次"存档" |
| **push** | 把本地的存档"上传"到 GitHub |

**仓库** = 一个文件夹 + 它的全部历史记录。

---

## 一、第一次配置（只做一次）

按 `Command + 空格`，输入 `终端`，回车打开终端。

✅ **本仓库已经帮你配好了**（`user.name` = `wangq7289-png`，`user.email` = `wangq7289@gmail.com`），这一步可以跳过。
下面两行留给「以后新建别的仓库」用（`--global` 是全局生效）：

```bash
git config --global user.name "wangq7289-png"
git config --global user.email "wangq7289@gmail.com"
```

---

## 二、在 GitHub 上建一个空仓库

1. 打开 https://github.com 并登录
2. 右上角 `+` → `New repository`
3. **Repository name** 填 `soft-sensor-lab`
4. 选 **Public**（作品集要公开）
5. ⚠️ **不要**勾 "Add a README file"、不要选 .gitignore、不要选 license
   （本地已经有内容了，勾了反而会冲突）
6. 点 `Create repository`

建好后页面会给你一个地址，形如：

```
https://github.com/wangq7289-png/soft-sensor-lab.git
```

**复制它**，下一步要用。

---

## 三、把本地连上去并上传

回到终端（如果代理开着，先执行前两行）：

```bash
cd ~/Desktop/softsensor

# GitHub 在国内直连常常不通，先设置代理（端口按你实际的改，Clash 一般是 7897）
export HTTPS_PROXY=http://127.0.0.1:7897
export HTTP_PROXY=http://127.0.0.1:7897

# 告诉 git 远程仓库在哪（换成你刚复制的地址）
git remote add origin https://github.com/wangq7289-png/soft-sensor-lab.git

# 把默认分支命名为 main
git branch -M main

# 上传
git push -u origin main
```

### 第一次会要你登录

GitHub 现在不能用密码，要用 **Personal Access Token**：

1. GitHub 网页 → 右上角头像 → `Settings`
2. 左侧最下面 `Developer settings` → `Personal access tokens` → `Tokens (classic)`
3. `Generate new token (classic)`，勾选 **`repo`** 权限，有效期选 90 天
4. 生成后**立刻复制那串 token**（只显示一次）
5. push 时提示输密码，就**粘贴这个 token**

> 也可能直接弹出浏览器让你授权，那就跟着点。

---

## 四、之后每天怎么用（就三条命令）

```bash
cd ~/Desktop/softsensor
git add -A
git commit -m "今天做了什么"
git push
```

**或者更省事**：双击文件夹里的 `上传到github.command`，它自动做完这三步。

| 命令 | 人话 |
|---|---|
| `git add -A` | 把今天的改动挑出来 |
| `git commit -m "..."` | 存档，并写一句说明 |
| `git push` | 上传到 GitHub |

### 说明怎么写（别写 "update"）

- ✅ `完成 A01：给 SAEV0.2.py 加了 RMSE 输出`
- ✅ `补了 D2 课堂笔记`
- ❌ `更新`、`fix`、`1`

---

## 五、常见问题

**Q：push 卡住不动 / 报 timeout？**
A：网络问题。确认代理开着，并且执行过上面那两行 `export`。

**Q：提示 `failed to push some refs`？**
A：GitHub 上比你本地新。先 `git pull --rebase`，再 `git push`。

**Q：想看看自己改了哪些文件？**
A：`git status`。想看具体改了什么：`git diff`。

**Q：传错了想撤销？**
A：先别乱敲命令，来问我。

**Q：怎么确认没把不该传的东西传上去？**
A：双击 `检查要上传什么.command`，它会列出所有会被上传的文件和改动，并扫描常见敏感信息（密码、token 等）。养成 push 前跑一遍的习惯。

---

## 六、一张图记住整个流程

```
写代码 / 写笔记   →   git add -A   →   git commit -m "说明"   →   git push   →   GitHub 上能看到
    (VSCode)          (挑改动)            (存档)                  (上传)
```

**每天就这一套。养成习惯后只要 20 秒。**
