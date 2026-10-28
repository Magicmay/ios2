# GitHub 上传助手

Write-Host "================================" -ForegroundColor Cyan
Write-Host "AutoTimezone GitHub 上传助手" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Git
Write-Host "检查 Git 安装..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>$null
    Write-Host "✅ Git 已安装: $gitVersion" -ForegroundColor Green
    $hasGit = $true
} catch {
    Write-Host "❌ Git 未安装或未重启 PowerShell" -ForegroundColor Red
    $hasGit = $false
}

Write-Host ""
Write-Host "请选择上传方式：" -ForegroundColor Green
Write-Host ""
Write-Host "1. 使用 Git 命令行（需要先重启 PowerShell）" -ForegroundColor White
Write-Host "2. 使用 GitHub Desktop（推荐，图形界面）" -ForegroundColor White
Write-Host "3. 手动上传到 GitHub（网页版）" -ForegroundColor White
Write-Host "4. 压缩项目以便传输" -ForegroundColor White
Write-Host ""

$choice = Read-Host "请选择 (1/2/3/4)"

switch ($choice) {
    "1" {
        if (-not $hasGit) {
            Write-Host ""
            Write-Host "请先执行以下操作：" -ForegroundColor Yellow
            Write-Host "1. 如果刚安装 Git，请关闭并重新打开 PowerShell" -ForegroundColor White
            Write-Host "2. 如果还没安装，请访问: https://git-scm.com/download/win" -ForegroundColor White
            Write-Host ""
            Read-Host "按回车键退出"
            exit
        }

        Write-Host ""
        Write-Host "=== Git 命令行上传步骤 ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "首先，请在 GitHub 上创建仓库：" -ForegroundColor Yellow
        Write-Host "1. 访问 https://github.com/new" -ForegroundColor White
        Write-Host "2. Repository name: ios-timezone-tweak" -ForegroundColor White
        Write-Host "3. 选择 Public（免费使用 Actions）" -ForegroundColor White
        Write-Host "4. 不要勾选任何初始化选项" -ForegroundColor White
        Write-Host "5. 点击 Create repository" -ForegroundColor White
        Write-Host ""

        $created = Read-Host "已创建 GitHub 仓库？(y/n)"

        if ($created -eq "y") {
            Write-Host ""
            $username = Read-Host "请输入你的 GitHub 用户名"

            Write-Host ""
            Write-Host "开始上传..." -ForegroundColor Yellow
            Write-Host ""

            # 初始化 Git
            Write-Host "1/5 初始化 Git 仓库..." -ForegroundColor Cyan
            git init

            # 添加文件
            Write-Host "2/5 添加文件..." -ForegroundColor Cyan
            git add .

            # 提交
            Write-Host "3/5 创建提交..." -ForegroundColor Cyan
            git commit -m "Initial commit: AutoTimezone iOS Tweak"

            # 设置远程仓库
            Write-Host "4/5 连接到 GitHub..." -ForegroundColor Cyan
            git remote add origin "https://github.com/$username/ios-timezone-tweak.git"
            git branch -M main

            # 推送
            Write-Host "5/5 推送到 GitHub..." -ForegroundColor Cyan
            Write-Host ""
            Write-Host "可能需要输入 GitHub 用户名和密码（或 Personal Access Token）" -ForegroundColor Yellow
            git push -u origin main

            Write-Host ""
            Write-Host "✅ 上传完成！" -ForegroundColor Green
            Write-Host ""
            Write-Host "下一步：" -ForegroundColor Yellow
            Write-Host "1. 访问 https://github.com/$username/ios-timezone-tweak" -ForegroundColor White
            Write-Host "2. 点击 'Actions' 标签查看自动编译进度" -ForegroundColor White
            Write-Host "3. 等待编译完成后下载 .deb 文件" -ForegroundColor White
        }
    }
    "2" {
        Write-Host ""
        Write-Host "=== 使用 GitHub Desktop ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "步骤：" -ForegroundColor Yellow
        Write-Host "1. 下载 GitHub Desktop: https://desktop.github.com/" -ForegroundColor White
        Write-Host "2. 安装并登录你的 GitHub 账号" -ForegroundColor White
        Write-Host "3. 点击 'File' → 'Add Local Repository'" -ForegroundColor White
        Write-Host "4. 选择这个文件夹: $PWD" -ForegroundColor White
        Write-Host "5. 如果提示未初始化，点击 'create a repository'" -ForegroundColor White
        Write-Host "6. 填写 Summary，点击 'Commit to main'" -ForegroundColor White
        Write-Host "7. 点击 'Publish repository'" -ForegroundColor White
        Write-Host "8. 确保选择 'Public'，取消勾选 'Keep this code private'" -ForegroundColor White
        Write-Host "9. 点击 'Publish Repository'" -ForegroundColor White
        Write-Host ""
        Write-Host "正在打开下载页面..." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        Start-Process "https://desktop.github.com/"
    }
    "3" {
        Write-Host ""
        Write-Host "=== 手动上传到 GitHub ===" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "步骤：" -ForegroundColor Yellow
        Write-Host "1. 访问 https://github.com/new 创建新仓库" -ForegroundColor White
        Write-Host "   - 名称: ios-timezone-tweak" -ForegroundColor White
        Write-Host "   - 选择 Public" -ForegroundColor White
        Write-Host "   - 点击 Create repository" -ForegroundColor White
        Write-Host ""
        Write-Host "2. 在新仓库页面，点击 'uploading an existing file'" -ForegroundColor White
        Write-Host ""
        Write-Host "3. 将以下文件夹内容拖到网页中：" -ForegroundColor White
        Write-Host "   $PWD" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "⚠️  重要：必须保持文件夹结构！" -ForegroundColor Red
        Write-Host "   特别是 .github/workflows/build.yml 文件" -ForegroundColor Red
        Write-Host ""
        Write-Host "4. 点击 'Commit changes'" -ForegroundColor White
        Write-Host ""
        Write-Host "5. 等待几分钟后，点击 'Actions' 标签查看编译" -ForegroundColor White
        Write-Host ""

        $openGithub = Read-Host "是否打开 GitHub？(y/n)"
        if ($openGithub -eq "y") {
            Start-Process "https://github.com/new"
        }
    }
    "4" {
        Write-Host ""
        Write-Host "=== 压缩项目 ===" -ForegroundColor Cyan
        Write-Host ""

        $zipPath = "$PWD\..\ios-timezone-tweak.zip"

        Write-Host "正在压缩..." -ForegroundColor Yellow

        if (Test-Path $zipPath) {
            Remove-Item $zipPath -Force
        }

        Compress-Archive -Path "$PWD\*" -DestinationPath $zipPath -Force

        Write-Host "✅ 压缩完成！" -ForegroundColor Green
        Write-Host ""
        Write-Host "文件位置: $zipPath" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "你可以：" -ForegroundColor Yellow
        Write-Host "- 传输到有 Git 的电脑上解压并上传" -ForegroundColor White
        Write-Host "- 或在 GitHub 网页版直接上传解压后的文件" -ForegroundColor White
        Write-Host ""

        $openFolder = Read-Host "是否打开文件夹？(y/n)"
        if ($openFolder -eq "y") {
            explorer.exe (Split-Path $zipPath)
        }
    }
    default {
        Write-Host "无效选择" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Read-Host "按回车键退出"
