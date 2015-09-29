require 'watir-webdriver'
require 'watir-webdriver/wait'
require_relative 'libs/iframe/session'


driver=Watir::Browser.new :chrome
=begin
driver.goto "http://www.wangmin.test.zrcaifu.com/register"
driver.text_field(:xpath=> '//*[@id="register-ul"]/li[1]/input').when_present.set("13500000084")
driver.text_field(:xpath=> '//*[@id="register-ul"]/li[2]/input').when_present.click
#driver.text_field(:xpath=> '//*[@id="sendsms-for-regiter"]').when_present.click
#sleep 3
#Sessiondiy.rui(driver,'注册')
p driver.cookies.to_a
=end
driver.goto "http://www.wangmin.test.zrcaifu.com"
driver.window.maximize
driver.goto "http://www.wangmin.test.zrcaifu.com/login"
driver.a(:xpath=>'//*[@id="Zr_TopNavbar"]/div/a[3]').when_present.click
driver.text_field(:xpath=>"//div[@id='dialog-public-login' and @style='display: block;']//*[contains(@class,'new-phone-email new-input-blur')]").when_present.set("123456")
#p driver.text
#a={:xpath=> '/html/body/div[7]/div[1]/div[1]/div[2]/div/div[1]/div[5]/a'}
#driver.a(:xpath=>'//*[@id="dialog-public-login"]/div[4]/div[1]/form/a[1]').when_present.fire_event :click


