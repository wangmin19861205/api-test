Given /前提:用户登录账户(.*)密码(.*)/ do |username,password|
  login_world(username,password)
end

Given /清空redis/ do
  clear_redis
end

Given /等待(.*)秒/ do |no|
  sleep(no.to_i)
end

Given /更新数据库的全部消息为未读未删除/ do
  update_message_disable_read_false
end

Given /删除数据库中已存在的用户名(.*)/ do |username|
  delete_userinfo username
end
