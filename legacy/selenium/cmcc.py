from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import Select
import os
import time


def school_login():
    print("启动Edge浏览器...")

    options = webdriver.EdgeOptions()
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--ignore-ssl-errors')
    driver = webdriver.Edge(options=options)

    login_url = "http://10.160.63.9/"
    print(f"访问登录页面: {login_url}")
    driver.get(login_url)

    try:
        wait = WebDriverWait(driver, 0.5)
        print("页面加载中...")
        wait.until(EC.presence_of_element_located((By.TAG_NAME, "body")))
        print(f"当前URL: {driver.current_url}")

        # 读取账号密码
        desktop_path = os.path.join(os.path.expanduser("~"), "Desktop", "账号.txt")
        print(f"读取文件: {desktop_path}")

        with open(desktop_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            username = lines[0].strip()
            password = lines[1].strip() if len(lines) > 1 else ""

        print(f"用户名: {username}")

        # 运营商选择
        print("选择运营商...")
        time.sleep(2)

        try:
            isp_select = wait.until(
                EC.presence_of_element_located((By.NAME, "ISP_select"))
            )
            select = Select(isp_select)
            select.select_by_value("@cmcc")
            print("已选择中国移动")
        except Exception as e:
            print(f"运营商选择失败: {e}")
            print("请手动选择运营商")

        # 选择器列表
        username_selectors = [
            'input[name="DDDDD"]',
            'input[name="username"]',
            'input[type="text"]',
            '#username',
            '.username'
        ]

        password_selectors = [
            'input[name="upass"]',
            'input[name="password"]',
            'input[type="password"]',
            '#password',
            '.password'
        ]

        login_button_selectors = [
            'input[type="submit"]',
            'button[type="submit"]',
            '.login-btn',
            '#loginBtn',
            'input[value="登录"]'
        ]

        # 填写账号
        username_filled = False
        for selector in username_selectors:
            try:
                username_input = wait.until(
                    EC.presence_of_element_located((By.CSS_SELECTOR, selector))
                )
                username_input.clear()
                username_input.send_keys(username)
                print(f"已填写用户名: {username}")
                username_filled = True
                break
            except:
                continue

        # 填写密码
        password_filled = False
        for selector in password_selectors:
            try:
                password_input = wait.until(
                    EC.presence_of_element_located((By.CSS_SELECTOR, selector))
                )
                password_input.clear()
                password_input.send_keys(password)
                print("已填写密码")
                password_filled = True
                break
            except:
                continue

        # 点击登录按钮
        login_clicked = False
        for selector in login_button_selectors:
            try:
                login_button = wait.until(
                    EC.element_to_be_clickable((By.CSS_SELECTOR, selector))
                )
                driver.execute_script("arguments[0].click();", login_button)
                print("已点击登录按钮")
                login_clicked = True

                print("等待登录响应...")
                time.sleep(5)
                print(f"登录后URL: {driver.current_url}")
                break
            except Exception as e:
                continue

        if not username_filled or not password_filled:
            print("未找到输入框，请手动填写")
            input("手动填写后按回车继续...")
        elif not login_clicked:
            print("未找到登录按钮，请手动点击")
            input("手动登录后按回车继续...")
        else:
            print("自动登录完成")

    except Exception as e:
        print(f"错误: {e}")
        input("按回车退出...")

    finally:
        print("浏览器保持打开")
        input("按回车退出程序...")
        driver.quit()


if __name__ == "__main__":
    school_login()