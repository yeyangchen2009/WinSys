# 撤销代码文件预览窗格配置
# 用法:打开powershell，输入下面命令行，回车。
# ` irm https://raw.githubusercontent.com/yeyangchen2009/WinSys/refs/heads/main/uninstall-code-preview.ps1 | iex `

$ErrorActionPreference = "Stop"

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

$count = 0
foreach ($ext in $extensions) {
    try {
        $basePath = "HKCU:\Software\Classes\$ext"
        $shellexPath = "$basePath\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}"

        # 删除预览处理程序子键
        if (Test-Path $shellexPath) {
            Remove-Item -Path "$basePath\shellex" -Recurse -Force
            $count++
        }

        # 删除 PerceivedType 属性
        if (Test-Path $basePath) {
            Remove-ItemProperty -Path $basePath -Name "PerceivedType" -ErrorAction SilentlyContinue
        }

        # 如果扩展名键下已空，可选清理（保留，避免破坏其他关联）
        Write-Host "  ✓ 已清理 $ext" -ForegroundColor Green
    }
    catch {
        Write-Warning "  ✗ $ext 清理失败: $_"
    }
}

Write-Host "`n共清理 $count 种文件类型的预览配置。" -ForegroundColor Cyan
