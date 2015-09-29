
Given /验证登录页面title/ do
  mobile=Login.new(@driver)
  data=mobile.pagetitle
  expect(data).to eq("登录")
end

Given /输入用户名(.*)密码(.*)登录,成功后返回首页/ do |username,password|
  mobile=Login.new(@driver)
  mobile.login(username,password)
end

Given /从登录页进入注册页/ do
  mobile=Login.new(@driver)
  mobile.to_register
end



