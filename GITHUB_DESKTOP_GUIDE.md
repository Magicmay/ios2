# 使用 GitHub Desktop 上传项目（最简单方法）

## 步骤 1：下载并安装 GitHub Desktop

1. 下载地址已打开：https://desktop.github.com/
2. 下载并安装
3. 安装完成后启动 GitHub Desktop

## 步骤 2：登录 GitHub 账号

1. 打开 GitHub Desktop
2. 点击 **"Sign in to GitHub.com"**
3. 在浏览器中登录你的 GitHub 账号
4. 授权 GitHub Desktop

如果没有 GitHub 账号：
- 访问 https://github.com/signup
- 注册一个免费账号

## 步骤 3：添加本地仓库

1. 在 GitHub Desktop 中，点击左上角 **"File"** → **"Add Local Repository"**
2. 点击 **"Choose..."** 按钮
3. 选择这个文件夹：
   ```
   E:\newAutoGmail\ios-timezone-tweak
   ```
4. 点击 **"Add Repository"**

如果提示 **"This directory does not appear to be a Git repository"**：
- 点击 **"create a repository"** 链接
- 或点击 **"Initialize Git Repository"**

## 步骤 4：创建初始提交

1. 在左下角的 **"Summary"** 框中输入：
   ```
   Initial commit
   ```
2. 在 **"Description"** 框中输入（可选）：
   ```
   AutoTimezone - Auto timezone tweak for iOS based on IP
   ```
3. 点击蓝色的 **"Commit to main"** 按钮

## 步骤 5：发布到 GitHub

1. 点击顶部的 **"Publish repository"** 按钮
2. 在弹出窗口中：
   - **Name**: 保持 `ios-timezone-tweak`
   - **Description**: `Auto timezone tweak for iOS`
   - ⚠️ **重要**：取消勾选 **"Keep this code private"**（必须是 Public 才能免费使用 GitHub Actions）
3. 点击 **"Publish Repository"** 按钮

等待上传完成...

## 步骤 6：查看自动编译

1. 上传完成后，在 GitHub Desktop 中点击 **"Repository"** → **"View on GitHub"**
2. 或直接访问：`https://github.com/你的用户名/ios-timezone-tweak`
3. 点击顶部的 **"Actions"** 标签
4. 你会看到 **"Build iOS Tweak"** 工作流正在运行
5. 等待 2-5 分钟，直到显示 ✅ 绿色勾号

## 步骤 7：下载编译好的 .deb 文件

1. 点击已完成的构建（绿色勾号）
2. 向下滚动到页面底部的 **"Artifacts"** 部分
3. 点击 **"AutoTimezone-Package"** 下载
4. 解压下载的 ZIP 文件
5. 得到 `.deb` 文件（例如：`com.yourdomain.autotimezone_1.0.0_iphoneos-arm.deb`）

## 步骤 8：传输到 iPhone

### 方式 A - iCloud Drive（推荐）
1. 将 `.deb` 文件上传到 iCloud Drive
2. 在 iPhone 的**文件** App 中找到它
3. 长按文件 → **共享** → **存储到"文件"** → 选择位置
4. 在 Filza 中打开该位置

### 方式 B - 邮件
1. 将 `.deb` 文件作为附件发送到你的邮箱
2. 在 iPhone 上打开邮件
3. 下载附件
4. 用 Filza 打开

### 方式 C - SSH
```powershell
scp com.yourdomain.autotimezone_1.0.0_iphoneos-arm.deb root@你的iPhone的IP:/var/root/
```

## 步骤 9：在 iPhone 上安装

1. 在 iPhone 上打开 **Filza**
2. 找到 `.deb` 文件
3. 点击文件
4. 点击右上角的 **"安装"**
5. 等待完成
6. 点击 **"重启 SpringBoard"**

## 步骤 10：配置和使用

1. 打开 **设置**
2. 向下滚动找到 **"AutoTimezone"**
3. 开启 **"启用自动时区"**
4. 点击 **"立即更新时区"** 测试

✅ **完成！** 你的 iPhone 现在会自动根据 IP 更新时区了！

---

## 🔍 故障排除

### Actions 构建失败
- 检查是否选择了 **Public** 仓库
- 查看 Actions 日志了解错误

### 无法下载 Artifacts
- 确保已登录 GitHub
- 确保构建成功完成（绿色勾号）

### 设置中找不到 AutoTimezone
- SSH 到手机执行：`uicache -a`
- 重启 SpringBoard：`killall -9 SpringBoard`

---

## 📞 需要帮助？

如果遇到问题，请告诉我：
1. 在哪个步骤遇到问题
2. 具体的错误信息
3. 截图（如果有）
