# 🚀 快速开始：安装到 iPhone 12

## 最简单的安装方法（推荐）

### 步骤 1️⃣：获取编译好的插件

**方法 A - 使用 GitHub Actions 自动编译（推荐）**

1. 将这个项目上传到 GitHub
2. GitHub 会自动编译（已配置好）
3. 在 GitHub 项目页面，点击 **Actions** 标签
4. 选择最新的编译任务
5. 下载 **AutoTimezone-Package** 文件
6. 解压得到 `.deb` 文件

**方法 B - 使用 WSL 编译**

```bash
# 在 WSL (Ubuntu) 中执行
# 1. 安装 Theos
bash <(curl -s https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)

# 2. 进入项目目录
cd /mnt/e/newAutoGmail/ios-timezone-tweak

# 3. 编译
make package

# 4. 编译好的 .deb 在 packages/ 目录
```

---

### 步骤 2️⃣：传输到 iPhone

**方法 1 - 使用 AirDrop（最简单）**
- 将 `.deb` 文件 AirDrop 到 iPhone
- 用 Filza 打开

**方法 2 - 使用 iCloud Drive**
- 上传 `.deb` 到 iCloud
- 在 iPhone 上下载
- 用 Filza 打开

**方法 3 - 使用 SSH**
```powershell
# 在 Windows PowerShell 中执行
scp packages\*.deb root@你的iPhone的IP:/var/root/
```

---

### 步骤 3️⃣：在 iPhone 上安装

**使用 Filza（最简单）：**

1. 打开 **Filza** 应用
2. 找到 `.deb` 文件的位置
3. 点击 `.deb` 文件
4. 点击右上角 **"安装"**
5. 等待安装完成
6. 点击 **"重启 SpringBoard"**

**使用终端（NewTerm 2 或 SSH）：**

```bash
# SSH 连接到 iPhone
ssh root@你的iPhone的IP
# 默认密码: alpine

# 安装插件
cd /var/root
dpkg -i com.yourdomain.autotimezone*.deb

# 重启 SpringBoard
killall -9 SpringBoard
```

---

### 步骤 4️⃣：配置和使用

1. 打开 **设置** 应用
2. 向下滚动，找到 **AutoTimezone**
3. 打开 **"启用自动时区"** 开关
4. 点击 **"立即更新时区"** 测试功能

✅ 完成！插件现在会自动根据 IP 地址更新时区

---

## 验证安装

### 检查插件是否工作

**方法 1 - 查看设置**
- 设置 > AutoTimezone 是否出现

**方法 2 - 查看日志（SSH）**
```bash
ssh root@你的iPhone的IP
tail -f /var/log/syslog | grep AutoTimezone
```

应该看到：
```
[AutoTimezone] Plugin loaded
[AutoTimezone] Fetching timezone from IP...
[AutoTimezone] Updating timezone to: Asia/Shanghai
```

---

## 常见问题

### ❌ 设置中找不到 AutoTimezone

**原因：** PreferenceLoader 未正确加载

**解决：**
```bash
# SSH 到手机
uicache -a
killall -9 Preferences SpringBoard
```

### ❌ 时区没有更新

**检查：**
1. 确认已在设置中启用
2. 确认手机有网络连接
3. 手动点击"立即更新时区"
4. 查看系统日志

### ❌ 无法 SSH 连接

**确保：**
1. iPhone 已安装 OpenSSH
2. 手机和电脑在同一 WiFi
3. 使用正确的 IP 地址
4. 默认密码是 `alpine`

---

## 获取 iPhone IP 地址

在 iPhone 上：
1. 设置 > WiFi
2. 点击已连接的 WiFi 右边的 ⓘ
3. 查看 IP 地址（例如：192.168.1.100）

---

## 完整命令速查

```powershell
# Windows - 传输文件到 iPhone
scp packages\*.deb root@192.168.1.100:/var/root/

# Windows - SSH 连接 iPhone
ssh root@192.168.1.100

# iPhone - 安装插件
dpkg -i /var/root/*.deb

# iPhone - 重启 SpringBoard
killall -9 SpringBoard

# iPhone - 查看日志
tail -f /var/log/syslog | grep AutoTimezone

# iPhone - 卸载插件
dpkg -r com.yourdomain.autotimezone
```

---

## 需要帮助？

1. 查看 [INSTALL_GUIDE_CN.md](INSTALL_GUIDE_CN.md) 详细指南
2. 查看 [README.md](README.md) 功能说明
3. 运行 `install-helper.ps1` 获取交互式帮助

---

## 小提示 💡

- 首次安装建议修改 root 密码：`passwd root`
- 建议安装 NewTerm 2 终端应用以便调试
- 保持 Filza 和越狱工具更新到最新版本
- 安装前建议备份手机

---

**祝你使用愉快！🎉**
