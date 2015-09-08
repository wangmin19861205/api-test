Given /前提:用户登录账户<(.*)>密码<(.*)>/ do |username,password|
  login_world(username,password)
end

Given /清空redis/ do
  clear_redis
end

Given /等待(.*)秒/ do |no|
  sleep(no.to_i)
end

