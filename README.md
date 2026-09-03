# 苏科大校园网 (Dr.COM) 自动登录脚本

## 简介

本项目提供一个用于 **Dr.COM** 的校园网自动登录脚本，通过模拟浏览器 POST 请求完成登录，支持**校园网、中国移动、中国联通、中国电信**等多种运营商。  
脚本基于 `requests` 库，响应迅速，适合在命令行、开机自启或定时任务中使用。

>早期曾使用 Selenium 模拟浏览器操作，但速度较慢且依赖浏览器驱动；现已改用直接发送 HTTP 请求的方式（基于抓包分析），更加稳定高效。

## 依赖

- **Python 3.x**
- **requests** 库

## 一键配置

### 克隆或下载本项目

```bash

git clone https://github.com/36genhao2/USTS-internet.git
cd USTS-internet

```

### 双击运行 `setup.bat`
脚本会依次执行：
- 检查 Python 环境
- 自动安装 `requests` 依赖
- 提示输入**学号**、**密码**
- 选择**运营商**（1-校园网 / 2-移动 / 3-联通 / 4-电信）
- 自动将信息写入 `main.py`（并备份原文件为 `main.py.bak`）

### 执行登录
**方式一（命令行）：**
```bash

python main.py

```
如果一切正常，终端会显示登录成功或失败的信息。

**方式二（双击运行）：**

直接双击`main.py`文件

> **注意**:脚本会以命令行窗口形式运行，执行完毕后窗口可能自动关闭。建议先通过命令行运行一次，确认无误后再考虑双击使用。

## 项目结构

```
USTS-internet/
├── README.md # 项目说明
├── requirements.txt # 核心依赖
├── setup.bat # 一键初始化脚本（自动配置账号）
├── main.py # 主登录脚本（由 setup.bat 注入信息）
├── legacy/ # 历史版本存档（Selenium 版）
│ ├── README.md
│ ├── requirements.txt
│ ├── setup.bat
│ ├── unicom.py
│ ├── cmcc.py
│ ├── telecom.py
│ └── keda.py
└── .gitignore # 忽略敏感文件

```

## 注意事项

- 运行前请确保设备已连接到校园网（通常需先插入网线）。
- 脚本默认使用 **GB2312** 解析服务器返回内容，如出现乱码可尝试将 `response.encoding` 改为 `'utf-8'` 或 `'gbk'`。
- **安全提醒**：`main.py` 会明文保存你的账号密码，**切勿**将该文件提交到公开仓库（已加入 `.gitignore`）。
- 如需要定时自动登录，可使用 Windows 任务计划程序或 `cron` 定期执行该脚本。

## 旧版Selenium脚本

`legacy/` 目录下保留了早期基于 Selenium 的模拟登录脚本，**仅供历史参考**，不推荐日常使用。  
