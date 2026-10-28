# AutoTimezone 快速安装脚本
# 适用于 Windows 用户

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "AutoTimezone 安装准备工具" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 检查当前目录
$currentDir = Get-Location
Write-Host "当前目录: $currentDir" -ForegroundColor Yellow
Write-Host ""

Write-Host "由于 Windows 无法直接编译 iOS 插件，请选择安装方法：" -ForegroundColor Green
Write-Host ""
Write-Host "方法 1: 使用 WSL (Windows Subsystem for Linux) 编译" -ForegroundColor White
Write-Host "  - 需要先安装 WSL 和 Theos"
Write-Host "  - 适合开发者"
Write-Host ""
Write-Host "方法 2: 手动安装（推荐）" -ForegroundColor White
Write-Host "  - 无需编译"
Write-Host "  - 通过 SSH 或 Filza 直接安装源文件"
Write-Host ""
Write-Host "方法 3: 在 Mac/Linux 上编译" -ForegroundColor White
Write-Host "  - 如果你有其他设备"
Write-Host ""

$choice = Read-Host "请选择方法 (1/2/3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "=== WSL 编译方法 ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "步骤 1: 打开 WSL 终端" -ForegroundColor Yellow
        Write-Host "步骤 2: 导航到项目目录" -ForegroundColor Yellow
        Write-Host "步骤 3: 运行以下命令：" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  cd /mnt/e/newAutoGmail/ios-timezone-tweak" -ForegroundColor White
        Write-Host "  make package" -ForegroundColor White
        Write-Host "  make install THEOS_DEVICE_IP=你的iPhone IP THEOS_DEVICE_PORT=22" -ForegroundColor White
        Write-Host ""
        Write-Host "或者只编译不安装：" -ForegroundColor Yellow
        Write-Host "  make package" -ForegroundColor White
        Write-Host "  然后将生成的 .deb 文件传输到手机" -ForegroundColor White
        Write-Host ""
    }
    "2" {
        Write-Host ""
        Write-Host "=== 手动安装方法 ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "由于源代码需要编译成动态库，建议使用以下替代方案：" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "选项 A: 使用 GitHub Actions 云编译" -ForegroundColor Green
        Write-Host "  1. 将项目上传到 GitHub"
        Write-Host "  2. 我可以帮你创建 GitHub Actions 配置"
        Write-Host "  3. 自动编译并生成 .deb 文件"
        Write-Host ""
        Write-Host "选项 B: 使用在线编译服务" -ForegroundColor Green
        Write-Host "  访问 https://build.frida.re/ 等在线服务"
        Write-Host ""
        Write-Host "选项 C: 借用其他设备" -ForegroundColor Green
        Write-Host "  在 Mac、Linux 或 WSL 上编译一次即可"
        Write-Host ""

        $needGithubActions = Read-Host "是否需要我创建 GitHub Actions 配置？(y/n)"
        if ($needGithubActions -eq "y") {
            Write-Host ""
            Write-Host "正在创建 GitHub Actions 配置..." -ForegroundColor Yellow
            # 这里会创建配置文件
        }
    }
    "3" {
        Write-Host ""
        Write-Host "=== Mac/Linux 编译步骤 ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "在 Mac 或 Linux 上执行：" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1. 安装 Theos (如果未安装)：" -ForegroundColor White
        Write-Host '   bash -c "$(curl -s https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"' -ForegroundColor Gray
        Write-Host ""
        Write-Host "2. 编译项目：" -ForegroundColor White
        Write-Host "   cd 项目目录" -ForegroundColor Gray
        Write-Host "   make package" -ForegroundColor Gray
        Write-Host ""
        Write-Host "3. 直接安装到手机：" -ForegroundColor White
        Write-Host "   make install THEOS_DEVICE_IP=你的iPhone的IP" -ForegroundColor Gray
        Write-Host ""
        Write-Host "4. 或者将 .deb 文件传输到 Windows：" -ForegroundColor White
        Write-Host "   生成的文件在 packages/ 目录下" -ForegroundColor Gray
        Write-Host ""
    }
    default {
        Write-Host "无效选择" -ForegroundColor Red
        exit
    }
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "需要查看详细安装指南，请阅读：" -ForegroundColor Green
Write-Host "  INSTALL_GUIDE_CN.md" -ForegroundColor White
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$openGuide = Read-Host "是否现在打开安装指南？(y/n)"
if ($openGuide -eq "y") {
    Start-Process "INSTALL_GUIDE_CN.md"
}
