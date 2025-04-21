from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
import time

class AutomationTests:
    def __init__(self):
        chromedriver_path = "/usr/bin/chromedriver"
        self.driver = webdriver.Chrome(service=Service(chromedriver_path))

    def search_and_verify_results(self):
        print("\nStarting Google Search Test...")
        try:
            self.driver.get("https://www.google.com/")
            search_box = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.NAME, "q"))
            )
            search_box.send_keys("Gmail")
            search_box.send_keys(Keys.RETURN)

            WebDriverWait(self.driver, 10).until(
                EC.visibility_of_element_located((By.CSS_SELECTOR, 'h3'))
            )
            results = self.driver.find_elements(By.CSS_SELECTOR, 'h3')

            if results:
                print("Google Search Test: Search results found.")
            else:
                print("Google Search Test: No search results found.")
        except Exception as e:
            print(f"Error during search test: {e}")

    def login_and_verify(self, email, password):
        print("\nStarting Google Login Test...")
        try:
            self.driver.get("https://accounts.google.com/ServiceLogin")
            email_field = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.ID, "identifierId"))
            )
            email_field.send_keys(email)
            self.driver.find_element(By.ID, "identifierNext").click()

            #password_field = self.driver.find_element(By.NAME, "Passwd")
            password_field = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.NAME, "Passwd"))
            )
            password_field.send_keys(password)
            password_field.send_keys(Keys.RETURN)
            time.sleep(3)

            if "myaccount.google.com" in self.driver.current_url:
                print("Google Login Test: Login successful, redirected to inbox.")
            else:
                print(f"Google Login Test: Login failed. Current URL: {self.driver.current_url}")
        except Exception as e:
            print(f"Error during login test: {e}")

    def verify_inbox_email(self):
        print("\nStarting Gmail Inbox Test...")
        try:
            self.driver.get("https://mail.google.com/mail/u/0/#inbox")
            time.sleep(5)  # Allow inbox to load
            emails = self.driver.find_elements(By.CSS_SELECTOR, '.zA')

            if emails:
                first_email = emails[0]
                sender = first_email.find_element(By.CSS_SELECTOR, '.yX.xY').text
                subject = first_email.find_element(By.CSS_SELECTOR, '.bog').text
                body = first_email.find_element(By.CSS_SELECTOR, '.y2').text

                print(f"Email from: {sender}\nSubject: {subject}\nBody: {body}")

                attachments = first_email.find_elements(By.CSS_SELECTOR, '.aQv')
                if attachments:
                    print("Gmail Inbox Test: Attachments found in email.")
                else:
                    print("Gmail Inbox Test: No attachments in email.")
            else:
                print("Gmail Inbox Test: No emails found in inbox.")
        except Exception as e:
            print(f"Error during inbox verification: {e}")

    def run_all_tests(self, email, password):
        try:
            self.search_and_verify_results()
            self.login_and_verify(email, password)
            self.verify_inbox_email()
        except Exception as e:
            print(f"Test run failed: {e}")
        finally:
            input("\nPress Enter to close the browser...")  # Wait so you can see results
            self.driver.quit()


automation = AutomationTests()
automation.run_all_tests("funbun@cit.edu.in", "supersecurehhhhhhh...")

