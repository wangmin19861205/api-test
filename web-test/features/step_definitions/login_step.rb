require_relative '../../pageobject/login_page'


Given /用户窗口登录(.*),(.*)/ do |username,password|
  webapp=Loginpage.new(@driver)
  webapp.login_dialog username,password
end

Given /用户页面登录(.*),(.*)/ do |username,password|
  webapp=Loginpage.new(@driver)
  webapp.login_page username,password
end



