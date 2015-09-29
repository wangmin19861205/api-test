require 'selenium-webdriver'


driver=Selenium::WebDriver.for :chrome
driver.navigate.to "https://www.zrcaifu.com/"
driver.find_element(xpath: '//*[@id="Zr_TopNavbar"]/div/a[3]').click
sleep 1
driver.find_element(xpath: '//*[@id="dialog"]')
driver.find_element(xpath: '//*[@id="dialog-public-login"]/div[4]/div[1]/form/div[1]/input').send_key("13522228410")
driver.find_element(xpath: '//*[@id="dialog-public-login"]/div[4]/div[1]/form/div[2]/input').send_key("wangmin105")
driver.find_element(xpath: '//*[@id="dialog-public-login"]/div[4]/div[1]/form/button').click
sleep 2
driver.find_element(xpath: '//*[@id="Zr_Navbar"]/div[3]/div[3]/a').click
sleep 2
driver.find_element(xpath: '//*[@id="left-menu"]/div/ul/li[8]/div/a[2]/span').click
driver.find_element(xpath: '//*[@id="lottery"]/table/tbody/tr[2]/td[2]/a/p').click

