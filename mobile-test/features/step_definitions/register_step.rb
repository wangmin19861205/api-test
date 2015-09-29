
Given /验证注册页面title/ do
  mobile=Register.new(@driver)
  data=mobile.pagetitle
  expect(data).to eq("注册")
end

Given /输入用户名(.*)密码(.*)验证码(.*)注册/ do |username,password,code|
  mobile=Register.new(@driver)
  mobile.register(username,password,code)
end

Given /从注册页进入登录页/ do
  mobile=Register.new(@driver)
  mobile.to_login
end

Given /滑动手势(.*),(.*),(.*),(.*),间隔(.*)秒/ do |a,b,c,d,time|
  mobile=Register.new(@driver)
  mobile.swipe(a,b,c,d,time)
end




