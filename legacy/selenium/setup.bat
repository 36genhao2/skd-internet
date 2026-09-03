@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   Legacy Selenium 脚本 - 环境配置
echo ========================================

REM 检测 Python
echo 正在检测 Python 环境...
python --version >nul 2>&1
if errorlevel 1 (
    echo 错误：未找到 Python，请先安装 Python 并添加到 PATH。
    pause
    exit /b 1
)

for /f "delims=" %%i in ('python --version 2^>^&1') do set pyver=%%i
echo 检测到 %pyver%

REM 询问安装依赖
echo.
set /p install_deps="是否安装 Selenium 和 WebDriver Manager？(y/n，默认 y): "
if /i not "%install_deps%"=="n" (
    echo 正在安装依赖...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo 依赖安装失败，请检查网络或 pip 源。
        pause
        exit /b 1
    )
) else (
    echo 跳过依赖安装，请确保已手动安装 selenium 和 webdriver_manager。
)

REM 账号配置
echo.
echo 配置账号信息
echo 脚本会从桌面上的 "账号.txt" 读取学号和密码。
echo 第一行是学号
echo 第二行是密码
echo.

set /p input_username="请输入学号: "
set /p input_password="请输入密码: "

REM 写入桌面账号.txt
set desktop_path=%USERPROFILE%\Desktop
echo %input_username% > "%desktop_path%\账号.txt"
echo %input_password% >> "%desktop_path%\账号.txt"

echo.
echo 已创建桌面上的 账号.txt，内容已写入。
echo 你现在可以运行 Selenium 脚本进行测试。
pause