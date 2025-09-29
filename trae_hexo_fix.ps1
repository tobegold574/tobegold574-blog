# Trae环境Hexo修复脚本
# 专门解决Trae PowerShell环境中Node.js路径识别问题

Write-Host "=== Trae环境Hexo修复脚本 ===" -ForegroundColor Cyan

# 方法1: 直接使用完整路径
Write-Host "方法1: 使用完整路径调用Node.js" -ForegroundColor Yellow
if (Test-Path "D:\node.exe") {
    Write-Host "✓ 找到D:\node.exe" -ForegroundColor Green
    & "D:\node.exe" --version
} else {
    Write-Host "✗ 未找到D:\node.exe" -ForegroundColor Red
}

Write-Host ""

# 方法2: 创建临时别名
Write-Host "方法2: 创建临时别名" -ForegroundColor Yellow
Set-Alias -Name trae_node -Value "D:\node.exe" -Scope Global
Write-Host "✓ 创建别名 'trae_node'" -ForegroundColor Green
trae_node --version

Write-Host ""

# 方法3: 使用函数包装
Write-Host "方法3: 使用函数包装Hexo命令" -ForegroundColor Yellow
function Invoke-Hexo {
    param([string[]]$Arguments)
    & "D:\node.exe" "$PWD\blog\node_modules\hexo-cli\bin\hexo" $Arguments
}

Write-Host "✓ 创建函数 'Invoke-Hexo'" -ForegroundColor Green
Write-Host "使用方法: Invoke-Hexo generate" -ForegroundColor White

Write-Host ""

# 方法4: 检查并修复npm全局包路径
Write-Host "方法4: 检查npm全局包路径" -ForegroundColor Yellow
$npmPath = "C:\Users\汪子昱\AppData\Roaming\npm"
if (Test-Path $npmPath) {
    Write-Host "✓ 找到npm全局包路径: $npmPath" -ForegroundColor Green
    # 将npm路径添加到当前会话
    $env:PATH = "$npmPath;$env:PATH"
    Write-Host "✓ 已将npm路径添加到当前会话" -ForegroundColor Green
} else {
    Write-Host "✗ 未找到npm全局包路径" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== 修复完成 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "推荐使用方法3的函数包装方式:" -ForegroundColor Green
Write-Host "Invoke-Hexo generate  # 生成静态文件"
Write-Host "Invoke-Hexo server    # 启动本地服务器"
Write-Host "Invoke-Hexo clean     # 清理缓存"