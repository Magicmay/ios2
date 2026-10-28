# 使用 GitHub Actions 自动编译安装指南

## 📝 准备工作

### 步骤 1：安装 Git（如果还没有）

1. 下载 Git for Windows：https://git-scm.com/download/win
2. 安装时全部使用默认选项
3. 安装完成后，重启 PowerShell 或命令提示符

**验证安装：**
```powershell
git --version
```

---

## 🚀 上传到 GitHub 并自动编译

### 步骤 2：创建 GitHub 仓库

1. 打开 https://github.com
2. 登录你的账号（如果没有账号，需要先注册）
3. 点击右上角 **"+"** → **"New repository"**
4. 填写信息：
   - **Repository name**: `ios-timezone-tweak`
   - **Description**: `Auto timezone tweak for iOS based on IP`
   - **Public** 或 **Private**（选择 Public 才能免费使用 GitHub Actions）
   - ❌ 不要勾选 "Initialize this repository with a README"
5. 点击 **"Create repository"**

### 步骤 3：上传项目到 GitHub

**方法 A - 使用命令行（推荐）：**

在项目目录下打开 PowerShell，执行：

```powershell
# 1. 初始化 Git 仓库
git init

# 2. 添加所有文件
git add .

# 3. 创建第一个提交
git commit -m "Initial commit: AutoTimezone iOS Tweak"

# 4. 连接到 GitHub（替换成你的用户名）
git remote add origin https://github.com/你的用户名/ios-timezone-tweak.git

# 5. 推送到 GitHub
git branch -M main
git push -u origin main
```

**方法 B - 使用 GitHub Desktop（图形界面）：**

1. 下载 GitHub Desktop：https://desktop.github.com/
2. 安装并登录
3. 点击 **"Add"** → **"Add existing repository"**
4. 选择项目文件夹：`E:\newAutoGmail\ios-timezone-tweak`
5. 点击 **"Publish repository"**

**方法 C - 直接上传文件（最简单但不推荐）：**

1. 在 GitHub 仓库页面，点击 **"uploading an existing file"**
2. 将项目文件夹中的所有文件拖拽到网页
3. 点击 **"Commit changes"**

⚠️ **注意：必须保持文件夹结构！**

---

### 步骤 4：等待自动编译

1. 上传完成后，进入你的 GitHub 仓库
2. 点击顶部的 **"Actions"** 标签
3. 你会看到一个正在运行的工作流 "Build iOS Tweak"
4. 等待几分钟，直到显示 ✅ 绿色勾号（编译成功）

如果看到 ❌ 红色叉号，点击进去查看错误日志。

---

### 步骤 5：下载编译好的 .deb 文件

1. 在 **Actions** 页面，点击最新的成功构建
2. 向下滚动到 **"Artifacts"** 部分
3. 下载 **"AutoTimezone-Package"** 压缩包
4. 解压得到 `.deb` 文件（类似：`com.yourdomain.autotimezone_1.0.0_iphoneos-arm.deb`）

---

## 📱 安装到 iPhone 12

### 步骤 6：传输到 iPhone

**方法 1 - AirDrop（最简单）：**
1. 在 Windows 上先传到 Mac（如果有）
2. 从 Mac AirDrop 到 iPhone
3. 选择用 **Filza** 打开

**方法 2 - iCloud Drive：**
1. 将 `.deb` 文件上传到 iCloud Drive
2. 在 iPhone 的 **文件** App 中找到它
3. 长按文件 → **共享** → **拷贝到 Filza**

**方法 3 - 通过 USB（使用 iMazing 等工具）：**
1. 下载 iMazing：https://imazing.com/
2. 连接 iPhone
3. 传输文件到 iPhone 的文件系统

**方法 4 - SSH（需要知道 iPhone IP）：**
```powershell
# 在 Windows PowerShell 中
scp com.yourdomain.autotimezone_*.deb root@你的iPhone的IP:/var/root/
# 默认密码：alpine
```

---

### 步骤 7：使用 Filza 安装

1. 在 iPhone 上打开 **Filza** 应用
2. 找到 `.deb` 文件（通常在 `/var/mobile/Documents` 或 `/var/root`）
3. 点击 `.deb` 文件
4. 点击右上角的 **"安装"**
5. 等待安装完成（几秒钟）
6. 点击 **"重启 SpringBoard"**

---

### 步骤 8：配置插件

1. iPhone 重启 SpringBoard 后
2. 打开 **设置** App
3. 向下滚动，找到 **"AutoTimezone"**
4. 打开 **"启用自动时区"** 开关
5. 点击 **"立即更新时区"** 测试

✅ **完成！** 插件现在会自动根据 IP 更新时区。

---

## ✅ 验证安装

### 检查插件是否工作

打开 NewTerm 2 或通过 SSH 执行：

```bash
tail -f /var/log/syslog | grep AutoTimezone
```

应该看到类似输出：
```
[AutoTimezone] Plugin loaded
[AutoTimezone] Fetching timezone from IP...
[AutoTimezone] Updating timezone to: Asia/Shanghai
[AutoTimezone] Timezone updated successfully
```

---

## 🔧 故障排除

### 问题：GitHub Actions 构建失败

**解决：**
1. 检查是否正确上传了所有文件
2. 确保 `.github/workflows/build.yml` 文件存在
3. 查看 Actions 日志了解具体错误

### 问题：设置中找不到 AutoTimezone

**解决：**
```bash
# SSH 到 iPhone
ssh root@你的IP
uicache -a
killall -9 SpringBoard
```

### 问题：无法通过 SSH 连接

**确认：**
1. iPhone 已安装 OpenSSH（从 Cydia/Sileo）
2. iPhone 和电脑在同一 WiFi
3. 使用正确的 IP 地址
4. 默认密码是 `alpine`

---

## 📌 下次更新插件

如果你修改了代码，想重新编译：

```powershell
# 在项目目录
git add .
git commit -m "Update: 描述你的修改"
git push
```

GitHub Actions 会自动重新编译，再次下载 .deb 安装即可。

---

## 🎉 完成！

现在你的 iPhone 12 会自动根据 IP 地址更新时区了！

**享受自动时区功能！** 🌏✈️
