require_relative '../../pageobject/home_page'
require 'cucumber'

Given /用户进入首页/ do
  @mobile=Home.new(@driver)
  data=@mobile.in_home
  expect("中瑞财富").to eq(data)
end

Given /(.*)项目卡片等于:/ do |loantype,table|
  assdata=[]
  table.raw.each do |item|
      item.delete('')
      assdata.push item
  end
  if loantype == '新手'
    data=@mobile.newloancard
  elsif loantype == ''
    data=@mobile.loancard
  end
  expect(assdata).to eq(data)
end

Given /验证消息数量:(.*)/ do |no|
  data=@mobile.message
  expect(no).to eq(data)
end

Given /点击全部项目按钮/ do
  @mobile.in_allproject
end

Given /点击我的账户按钮/ do
  @mobile.in_account
end

Given /点击设置按钮/ do
  @mobile.in_myset
end


