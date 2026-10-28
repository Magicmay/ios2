# AutoTimezone - iOS 自动时区插件

## 简介

AutoTimezone 是一个 iOS 越狱插件，可以根据设备的 IP 地址自动检测并设置系统时区。适用于经常旅行或使用 VPN 的用户。

## 功能特性

- ✅ 根据 IP 地址自动检测时区
- ✅ 支持多个 IP 定位 API（主 API 失败时自动切换备用 API）
- ✅ 每 30 分钟自动检查时区更新
- ✅ WiFi 状态改变时自动更新
- ✅ 可在设置中手动触发立即更新
- ✅ 完整的系统时区设置（使用多种方法确保生效）
- ✅ 支持 iOS 14.0 及以上版本
- ✅ 针对 RootHide 越狱环境优化

## 系统要求

- iOS 14.0 或更高版本
- 越狱环境（推荐 RootHide）
- iPhone 16.1.1 测试通过

## 安装方法

### 使用 Theos 编译

1. 确保已安装 [Theos](https://theos.dev/)

2. 克隆或下载项目：
```bash
git clone <repository-url>
cd ios-timezone-tweak
```

3. 编译插件：
```bash
make package
```

4. 安装到设备：
```bash
make install
```

5. 重启 SpringBoard：
```bash
killall -9 SpringBoard
```

### 手动安装 DEB 包

1. 编译生成 DEB 包
2. 使用 Filza 或其他工具将 DEB 包传输到设备
3. 安装 DEB 包
4. 重启 SpringBoard

## 使用说明

### 首次设置

1. 安装插件后，打开 **设置** > **AutoTimezone**
2. 启用 **"启用自动时区"** 开关
3. 插件将在 5 秒后自动执行首次时区更新

### 手动更新时区

在设置页面中，点击 **"立即更新时区"** 按钮可以手动触发时区更新。

### 自动更新机制

插件会在以下情况下自动更新时区：

- SpringBoard 启动后 5 秒（等待网络初始化）
- 每 30 分钟定时检查
- WiFi 连接状态改变时（3 秒延迟）

## 工作原理

### 时区检测

插件使用以下 API 来检测时区：

1. **主 API**: [ip-api.com](http://ip-api.com/json/?fields=timezone)
2. **备用 API**: [ipapi.co](https://ipapi.co/json/)

### 时区设置

为确保时区设置能够完全生效，插件使用多种方法：

1. **私有 API**: `SetTimeZoneWithName()` - 最可靠的方法
2. **系统 API**: `NSTimeZone.setDefaultTimeZone()`
3. **用户偏好设置**: 更新多个配置文件和偏好域
4. **符号链接**: 更新 `/var/db/timezone/localtime` 符号链接
5. **系统通知**: 发送时区变更通知给所有进程

## 日志调试

插件会输出详细的日志信息，可以通过以下命令查看：

```bash
# 实时查看日志
tail -f /var/log/syslog | grep AutoTimezone

# 或使用 Console.app 过滤 "AutoTimezone"
```

日志内容包括：

- 插件加载状态
- API 请求结果
- 时区变更记录
- 错误信息

## 配置文件

插件的配置文件位于：
```
/var/mobile/Library/Preferences/com.yourdomain.autotimezone.plist
```

配置项：
- `enabled`: Boolean - 是否启用插件

## 已知问题

1. **网络要求**: 插件需要网络连接来获取 IP 定位信息
2. **API 限制**: 免费 IP 定位 API 可能有请求频率限制
3. **VPN 影响**: 使用 VPN 时，时区将根据 VPN 服务器的位置变化

## 故障排除

### 时区没有更新

1. 检查设置中是否启用了插件
2. 检查网络连接是否正常
3. 查看系统日志确认插件是否正常工作
4. 尝试点击"立即更新时区"手动触发

### 编译错误

1. 确保 Theos 正确安装并配置
2. 检查 SDK 版本是否正确
3. 确保设置了正确的 `$THEOS` 环境变量

## 技术细节

### 项目结构

```
ios-timezone-tweak/
├── Tweak.x                          # 主插件代码
├── Makefile                         # 主项目 Makefile
├── control                          # DEB 包信息
└── AutoTimezonePrefs/               # 设置面板
    ├── Makefile                     # 设置面板 Makefile
    ├── AutoTimezonePrefsRootListController.m  # 设置控制器
    └── Resources/
        └── Root.plist               # 设置界面定义
```

### Hook 说明

- **SpringBoard**: 在启动时初始化插件并开始定时器
- **SBWiFiManager**: 监听 WiFi 状态变化以触发更新

## 开发与贡献

欢迎提交 Issue 和 Pull Request！

### 开发环境

- macOS 或 Linux
- Theos
- iOS SDK

### 编译选项

可以在 `Makefile` 中修改以下选项：

- `TARGET`: iOS 版本和编译器
- `ARCHS`: 目标架构（arm64, arm64e）
- `INSTALL_TARGET_PROCESSES`: 安装后自动重启的进程

## 许可证

请根据您的需求添加适当的许可证。

## 更新日志

### v1.0.0 (初始版本)

- 根据 IP 地址自动检测并设置时区
- 支持多个 API 源
- 定时和事件触发的自动更新
- 设置面板支持手动更新

## 作者

Your Name

## 致谢

- Theos 开发团队
- IP 定位服务提供商（ip-api.com, ipapi.co）
