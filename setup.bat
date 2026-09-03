@echo off
setlocal enabledelayedexpansion

echo ========================================
echo     USTS联网初始化
echo ========================================

REM ---- 检查 Python ----
python --version >nul 2>&1
if errorlevel 1 (
    echo 错误：未找到 Python，请先安装并添加到 PATH。
    pause
    exit /b 1
)

REM ---- 显示 Python 版本 ----
for /f "delims=" %%i in ('python --version 2^>^&1') do set pyver=%%i
echo 检测到 %pyver%

REM ---- 检测 requests 是否已安装 ----
python -c "import requests" >nul 2>&1
if errorlevel 1 (
    echo requests 库未安装。
    set /p install_deps="是否安装 requests？(y/n，默认 y): "
    if /i not "!install_deps!"=="n" (
        echo 正在安装 requests...
        pip install requests
        if errorlevel 1 (
            echo 安装失败，请检查网络或 pip 源。
            pause
            exit /b 1
        )
    ) else (
        echo 跳过安装，请确保已手动安装 requests。
    )
) else (
    echo requests 已安装
)

echo.
echo ---- 请输入您的校园网账号信息 ----

set /p input_username="学号 (例如 20231145): "
set /p input_password="密码: "

echo.
echo 请选择运营商：
echo   1. 校园网 (@keda)
echo   2. 中国移动 (@cmcc)
echo   3. 中国联通 (@unicom)
echo   4. 中国电信 (@telecom)
set /p choice="输入编号 (1-4): "

if "%choice%"=="1" set carrier=@keda
if "%choice%"=="2" set carrier=@cmcc
if "%choice%"=="3" set carrier=@unicom
if "%choice%"=="4" set carrier=@telecom
if not defined carrier (
    echo 无效选择，默认使用 @unicom
    set carrier=@unicom
)

REM ---- 备份原始文件（可选） ----
if not exist main.py.bak (
    copy main.py main.py.bak >nul
    echo 已备份原文件为 main.py.bak
)

REM ---- 使用 PowerShell 精准替换变量 ----
powershell -Command ^
    $content = Get-Content -Path 'main.py' -Raw; ^
    $content = $content -replace '(?<=username = )".*?"', '"%input_username%"'; ^
    $content = $content -replace '(?<=password = )".*?"', '"%input_password%"'; ^
    $content = $content -replace '(?<=carrier_suffix = )".*?"', '"%carrier%"'; ^
    Set-Content -Path 'main.py' -Value $content -Encoding UTF8

if errorlevel 1 (
    echo 替换失败，请检查文件是否存在或是否有写权限。
    pause
    exit /b 1
)

echo.
echo 初始化完成！已将您的账号信息写入 main.py。
echo 您可以双击运行 python main.py 测试登录。
pause