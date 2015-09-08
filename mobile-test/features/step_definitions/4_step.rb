require_relative '../../pageobject/login_page'
require 'cucumber'

Given /验证登录页面title/ do
  mobile=Login.new(@driver)
  data=mobile.pagetitle
  expect("登录").to eq(data)
end

Given /输入用户名(.*)密码(.*)登录/ do |username,password|
  mobile=Login.new(@driver)
  mobile.login(username,password)
end



