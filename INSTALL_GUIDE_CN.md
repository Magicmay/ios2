# iPhone 12 越狱手机安装指南

## 前提条件

- ✅ iPhone 12 已越狱（RootHide 或其他越狱工具）
- ✅ 已安装 Filza File Manager 或 SSH 访问
- ✅ 手机和电脑在同一网络

## 安装方法（3种选择）

---

## 方法一：使用预编译 DEB 包（最简单）⭐推荐

### 步骤 1：编译 DEB 包

由于 Windows 环境无法直接编译，你需要：

**选项 A：使用 GitHub Actions 云编译**
1. 将项目上传到 GitHub
2. 配置 GitHub Actions 自动编译
3. 下载编译好的 .deb 文件

**选项 B：使用其他电脑编译**
1. 在 Mac 或 Linux 电脑上安装 Theos
2. 运行 `make package`
3. 将生成的 `.deb` 文件传输到 Windows

**选项 C：手动创建 DEB 包（无需编译器）**
- 我可以帮你创建手动安装脚本

### 步骤 2：安装到手机

**使用 Filza（最简单）：**
1. 将 `.deb` 文件通过 AirDrop、iCloud 或 USB 传输到手机
2. 打开 Filza，找到 `.deb` 文件
3. 点击文件，选择"安装"
4. 安装完成后，点击"重启 SpringBoard"

**使用 SSH：**
```bash
# 在电脑上（需要安装 SSH 客户端）
scp com.yourdomain.autotimezone_1.0.0_iphoneos-arm.deb root@你的手机IP:/var/root/

# 然后 SSH 连接到手机
ssh root@你的手机IP

# 在手机上安装
dpkg -i /var/root/com.yourdomain.autotimezone_1.0.0_iphoneos-arm.deb

# 重启 SpringBoard
killall -9 SpringBoard
```

---

## 方法二：手动安装文件（无需编译）⭐⭐推荐

如果无法编译 DEB 包，可以直接手动复制文件：

### 步骤 1：准备文件

我会为你创建一个安装脚本，将所有必要文件打包。

### 步骤 2：使用 Filza 安装

1. 将整个项目文件夹压缩为 ZIP
2. 传输到手机并解压
3. 使用 Filza 执行安装脚本
4. 重启 SpringBoard

---

## 方法三：使用 Sileo/Cydia 仓库（需要搭建仓库）

如果你经常安装插件，可以搭建个人仓库。

---

## 详细步骤：手动安装（方法二详解）

### 第 1 步：通过 SSH 连接手机

```bash
# Windows 用户在 PowerShell 或 CMD 中运行
ssh root@你的iPhone的IP地址

# 默认密码通常是：alpine
# 建议安装后立即修改密码！
```

### 第 2 步：创建必要目录

```bash
# 在手机上创建目录
mkdir -p /Library/MobileSubstrate/DynamicLibraries
mkdir -p /Library/PreferenceBundles
mkdir -p /Library/PreferenceLoader/Preferences
```

### 第 3 步：传输文件

**需要传输的文件：**

1. `AutoTimezone.dylib` → `/Library/MobileSubstrate/DynamicLibraries/`
2. `AutoTimezone.plist` → `/Library/MobileSubstrate/DynamicLibraries/`
3. `AutoTimezonePrefs.bundle` → `/Library/PreferenceBundles/`
4. `AutoTimezonePrefs.plist` → `/Library/PreferenceLoader/Preferences/`

### 第 4 步：设置权限

```bash
# 在手机上设置正确的权限
chmod 755 /Library/MobileSubstrate/DynamicLibraries/AutoTimezone.dylib
chmod 644 /Library/MobileSubstrate/DynamicLibraries/AutoTimezone.plist
chmod -R 755 /Library/PreferenceBundles/AutoTimezonePrefs.bundle
chmod 644 /Library/PreferenceLoader/Preferences/AutoTimezonePrefs.plist
```

### 第 5 步：重启 SpringBoard

```bash
# 在手机上执行
killall -9 SpringBoard
```

---

## 安装后配置

1. 打开 **设置** 应用
2. 向下滚动找到 **AutoTimezone**
3. 启用 **"启用自动时区"** 开关
4. 点击 **"立即更新时区"** 测试功能

---

## 验证安装

### 查看日志

```bash
# SSH 连接手机后执行
tail -f /var/log/syslog | grep AutoTimezone
```

你应该看到类似这样的日志：
```
[AutoTimezone] Plugin loaded
[AutoTimezone] Fetching timezone from IP...
[AutoTimezone] Updating timezone to: Asia/Shanghai
[AutoTimezone] Timezone updated successfully
```

---

## 故障排除

### 问题 1：设置中找不到插件选项

**解决方法：**
```bash
# 检查 PreferenceLoader 配置
ls -la /Library/PreferenceLoader/Preferences/AutoTimezonePrefs.plist

# 重新加载 PreferenceLoader
killall -9 Preferences
```

### 问题 2：插件不工作

**解决方法：**
```bash
# 检查插件是否加载
ls -la /Library/MobileSubstrate/DynamicLibraries/AutoTimezone.*

# 检查权限
chmod 755 /Library/MobileSubstrate/DynamicLibraries/AutoTimezone.dylib

# 完全重启手机（不是重启 SpringBoard）
reboot
```

### 问题 3：时区没有更新

**检查清单：**
1. ✅ 确认已在设置中启用插件
2. ✅ 确认手机有网络连接
3. ✅ 查看系统日志确认插件是否运行
4. ✅ 尝试手动点击"立即更新时区"按钮

---

## 卸载方法

### 使用 Filza：
1. 打开 Filza
2. 进入"已安装的软件包"
3. 找到 AutoTimezone
4. 点击卸载

### 手动卸载：
```bash
# SSH 连接手机后执行
rm /Library/MobileSubstrate/DynamicLibraries/AutoTimezone.*
rm -rf /Library/PreferenceBundles/AutoTimezonePrefs.bundle
rm /Library/PreferenceLoader/Preferences/AutoTimezonePrefs.plist
rm /var/mobile/Library/Preferences/com.yourdomain.autotimezone.plist

# 重启 SpringBoard
killall -9 SpringBoard
```

---

## 推荐工具

- **Filza File Manager**: 文件管理（必备）
- **NewTerm 2**: 终端模拟器（可选）
- **CocoaTop**: 进程监控（调试用）

---

## 安全建议

1. **修改默认密码**：
   ```bash
   passwd root
   passwd mobile
   ```

2. **备份手机**：
   - 安装前建议用 iTunes/Finder 备份
   - 或使用越狱工具的备份功能

3. **测试环境**：
   - 首次安装建议在非关键时段测试
   - 确保功能正常后再日常使用

---

## 需要帮助？

如果遇到问题，请提供：
1. 越狱类型和版本
2. iOS 版本
3. 系统日志输出
4. 具体错误信息
