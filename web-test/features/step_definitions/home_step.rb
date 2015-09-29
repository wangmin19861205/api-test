require_relative '../../pageobject/home_page'


Given /进入首页/ do
  webapp=Homepage.new(@driver)
  webapp.open_site
end

Given /去注册/ do
  webapp=Homepage.new(@driver)
  webapp.to_register
end

Given /去登录/ do
  webapp=Homepage.new(@driver)
  webapp.to_login
end

Given /切换到首页tab/ do
  webapp=Homepage.new(@driver)
  webapp.switch_home_tab
end

Given /切换到我要投资tab/ do
  webapp=Homepage.new(@driver)
  webapp.switch_allrporject_tab
end

Given /切换到我的账户tab/ do
  webapp=Homepage.new(@driver)
  webapp.switch_myaccount_tab
end

Given /切换到安全保障tab/ do
  webapp=Homepage.new(@driver)
  webapp.switch_safe_tab
end

Given /首页(.*)项目卡片等于:/ do |loantype,table|
  webapp=Homepage.new(@driver)
  assdata=[]
  table.raw.each do |item|
    item.delete('')
    assdata.push item
  end
  if loantype == '新手'
    data=webapp.newloancard
  elsif loantype == '推荐'
    data=webapp.loancard
  elsif loantype == 'VIP'
    data=webapp.viploancard
  end
  expect(data).to eq(assdata)
end

Given /去投资(.*)/ do |no|
  webapp=Homepage.new(@driver)
  webapp.to_investdetail no
end

Given /等待(.*)秒/ do |no|
  sleep(no.to_i)
end

Given /验证登录后的欢迎文本:(.*)/ do |assdata|
  webapp=Homepage.new(@driver)
  data=webapp.welcome_text
  expect(data).to eq(assdata)
end



