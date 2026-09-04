@echo off
chcp 65001 >nul
setlocal

REM ---- 切换到脚本所在目录 ----
cd /d "%~dp0"

echo ========================================
echo     USTS 校园网登录配置
echo ========================================

REM ---- 检查 Python ----
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Python，请先安装并加入 PATH。
    pause
    exit /b 1
)

for /f "delims=" %%i in ('python --version 2^>^&1') do set pyver=%%i
echo 检测到 %pyver%

REM ---- 检查 requests ----
python -c "import requests" >nul 2>&1
if errorlevel 1 (
    echo requests 尚未安装。
    set /p install_deps="是否安装 requests？(y/n，默认 y): "
    if /i not "%install_deps%"=="n" (
        echo 正在安装 requests...
        pip install requests
        if errorlevel 1 (
            echo 安装失败，请更换 pip 源后重试。
            pause
            exit /b 1
        )
    ) else (
        echo 跳过安装，请确认已手动安装 requests。
    )
) else (
    echo requests 已安装
)

echo.
echo ---- 配置校园网账号信息 ----

set /p input_username="学号: "
if "%input_username%"=="" (
    echo [错误] 学号不能为空。
    pause
    exit /b 1
)

set /p input_password="密码: "
if "%input_password%"=="" (
    echo [错误] 密码不能为空。
    pause
    exit /b 1
)

echo.
echo 请选择运营商：
echo   1. 校园网 (@keda)
echo   2. 中国移动 (@cmcc)
echo   3. 中国联通 (@unicom)
echo   4. 中国电信 (@telecom)
set /p choice="选择 (1-4): "

set carrier=@unicom
if "%choice%"=="1" set carrier=@keda
if "%choice%"=="2" set carrier=@cmcc
if "%choice%"=="3" set carrier=@unicom
if "%choice%"=="4" set carrier=@telecom

REM ---- 直接把账号信息写回 main.py ----
set "USTS_USER=%input_username%"
set "USTS_PASS=%input_password%"
set "USTS_CARRIER=%carrier%"
python -c "import os,re;q=chr(34).encode();b=open('main.py','rb').read();u=os.environ['USTS_USER'].encode('utf-8');p=os.environ['USTS_PASS'].encode('utf-8');c=os.environ['USTS_CARRIER'].encode('utf-8');b=re.sub(b'^username = '+q+b'[^'+q+b']*'+q,b'username = '+q+u+q,b,count=1,flags=re.M);b=re.sub(b'^password = '+q+b'[^'+q+b']*'+q,b'password = '+q+p+q,b,count=1,flags=re.M);b=re.sub(b'^carrier_suffix = '+q+b'[^'+q+b']*'+q,b'carrier_suffix = '+q+c+q,b,count=1,flags=re.M);open('main.py','wb').write(b)"
if errorlevel 1 (
    echo [错误] 写入 main.py 失败。
    pause
    exit /b 1
)

echo.
echo 已写入 main.py，验证中...
findstr /B /C:"username = " main.py | findstr /C:"%input_username%" >nul
if errorlevel 1 (
    echo [错误] 学号写入校验未通过，请手动检查 main.py。
) else (
    echo [验证] 学号已写入 main.py
)

findstr /B /C:"password = " main.py | findstr "." >nul
if errorlevel 1 (
    echo [错误] 密码写入校验未通过，请手动检查 main.py。
) else (
    echo [验证] 密码已写入 main.py
)

findstr /B /C:"carrier_suffix = " main.py | findstr /C:"%carrier%" >nul
if errorlevel 1 (
    echo [错误] 运营商写入校验未通过，请手动检查 main.py。
) else (
    echo [验证] 运营商已写入 main.py
)

echo.
echo 配置完成。双击运行 python main.py 即可登录。
pause