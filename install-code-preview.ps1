# 开启 Windows 资源管理器预览窗格对代码文件的文本预览支持
# 用法:打开powershell，输入下面命令行，回车。
# ` irm https://raw.githubusercontent.com/yeyangchen2009/WinSys/refs/heads/main/install-code-preview.ps1 | iex `

$ErrorActionPreference = "Stop"

# 定义需要配置的文件扩展名
$extensions = @(
    ".md", ".output", ".ass", ".srt", ".ef2",
    ".js", ".ts", ".tsx", ".jsx",
    ".json", ".jsonc",
    ".py", ".java", ".sql",
    ".sh", ".ps1", ".bat", ".cmd",
    ".yml", ".yaml", ".toml",
    ".html", ".css",
    ".gitignore", ".env",
    ".c", ".cpp",
    ".xml", ".ini", ".log"
)

# Windows 内置文本预览处理程序的 GUID
$previewGuid = "{1531d583-8375-4d3f-b5fb-d23bbd169f22}"
$shellexKey = "shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}"

$count = 0
foreach ($ext in $extensions) {
    try {
        # 构建注册表路径 (HKCU\Software\Classes 等效于 HKCR, 无需管理员权限)
        $basePath = "HKCU:\Software\Classes\$ext"
        $previewPath = "$basePath\$shellexKey"

        # 创建扩展名根键并设置 PerceivedType 为 text
        if (!(Test-Path $basePath)) {
            New-Item -Path $basePath -Force | Out-Null
        }
        Set-ItemProperty -Path $basePath -Name "PerceivedType" -Value "text" -Force

        # 创建 shellex 预览子键并设置默认值
        if (!(Test-Path $previewPath)) {
            New-Item -Path $previewPath -Force | Out-Null
        }
        Set-ItemProperty -Path $previewPath -Name "(Default)" -Value $previewGuid -Force

        $count++
        Write-Host "  ✓ $ext" -ForegroundColor Green
    }
    catch {
        Write-Warning "  ✗ $ext 配置失败: $_"
    }
}

Write-Host "`n共配置 $count 种文件类型的预览支持。按 Alt+P 在资源管理器中预览。" -ForegroundColor Cyan
