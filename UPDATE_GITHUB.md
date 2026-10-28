# 更新 GitHub 仓库（修复构建错误）

## 问题
GitHub Actions 构建失败，因为使用了已弃用的 actions 版本。

## 解决方案
我已经修复了 `.github/workflows/build.yml` 文件。

## 更新步骤（使用 GitHub Desktop）

1. **打开 GitHub Desktop**
   
2. **查看更改**
   - 你会看到 `.github/workflows/build.yml` 文件显示为已修改
   
3. **提交更改**
   - 在左下角的 **Summary** 框中输入：
     ```
     Fix: Update actions to v4
     ```
   - 点击 **"Commit to main"**
   
4. **推送到 GitHub**
   - 点击顶部的 **"Push origin"** 按钮
   
5. **查看新的构建**
   - 访问 GitHub 仓库的 **Actions** 标签
   - 新的构建会自动开始
   - 这次应该会成功 ✅

## 或使用命令行（如果 Git 已可用）

```powershell
git add .github/workflows/build.yml
git commit -m "Fix: Update actions to v4"
git push
```

---

更新后，GitHub Actions 会自动重新编译，等待 2-5 分钟后就能下载 .deb 文件了！
