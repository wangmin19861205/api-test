require_relative '../../pageobject/allproject_page'
require 'cucumber'

Given /验证全部项目页面title/ do
  mobile=Allproject.new(@driver)
  data=mobile.pagetitle
  expect(data).to eq("全部项目")
end

Given /切换到新手项目tab/ do
  mobile=Allproject.new(@driver)
  mobile.switch_newproject
end

Given /切换到短期项目tab/ do
  mobile=Allproject.new(@driver)
  mobile.switch_shortproject
end

Given /切换到中期项目tab/ do
  mobile=Allproject.new(@driver)
  mobile.switch_middleproject
end

Given /切换到长期项目tab/ do
  mobile=Allproject.new(@driver)
  mobile.switch_longproject
end

Given /切换到vip项目tab/ do
  mobile=Allproject.new(@driver)
  mobile.switch_vipproject
end

Given /全部项目卡片等于:/ do |table|
  mobile=Allproject.new(@driver)
  assdata=table.raw
  data=mobile.loancard
  expect(data).to eq(assdata)
end

Given /新手详情卡片等于:/ do |table|
  mobile=Allproject.new(@driver)
  assdata=table.raw[0]
  data=mobile.newloandetail
  expect(data).to eq(assdata)
end

Given /验证新手投资按钮文本等于(.*)/ do |assdata|
  mobile=Allproject.new(@driver)
  data=mobile.get_invest_button
  expect(data).to eq(assdata)
end

Given /验证新手投资邀请文本等于(.*)/ do |assdata|
  mobile=Allproject.new(@driver)
  data=mobile.get_invitefriend_text
  expect(data).to eq(assdata)
end
