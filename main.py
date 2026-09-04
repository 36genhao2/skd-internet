import requests

#setup.bat配置部分
username = ""   #账号
password = ""   #密码
carrier_suffix = ""   #运营商

#拼接完整的登录账号
full_username = username + carrier_suffix

#url
login_url = "http://10.160.63.9:801/eportal/?c=ACSetting&a=Login"

# Dr.COM 系统的固定参数
payload = {
    'DDDDD': f'{full_username}',   #完整账号
    'upass': password,   #密码
    'R1': '0',   #固定值
    'R2': '',   #固定值
    'R3': '0',   #固定值
    'R6': '0',   #固定值
    'para': '00',   #固定值
    '0MKKey': '123456'   #固定值
}

#设置请求头，模拟浏览器访问，防止被拦截
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Referer': 'http://10.160.63.9:801/eportal/?c=ACSetting&a=Login',   #来源页面
    'Accept-Language': 'zh-CN,zh;q=0.9',   #语言
}

#发送请求
try:
    #发送POST请求
    response = requests.post(login_url, data=payload, headers=headers, timeout=10)

    #检查响应内容，判断是否成功
    response.encoding = 'gb2312'  # Dr.COM系统常用编码

    #如果返回结果中包含 "成功" 或 "在线" 等字样，通常代表登录成功
    if "成功" in response.text or "在线" in response.text:
        print(f" {carrier_suffix} 登录成功！")
    else:
        print(f" 登录失败，请检查账号密码或网络。")

except Exception as e:

    print(f" 网络请求出错: {e}")
