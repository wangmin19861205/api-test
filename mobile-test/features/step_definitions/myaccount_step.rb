require_relative '../../pageobject/myaccount_page'
require 'cucumber'

Given /验证我的账户页面title/ do
  @mobile=Myaccount.new(@driver)
  data=@mobile.pagetitle
  expect(data).to eq("我的账户")
end

Given /验证我的资产:/ do |table|
  assdata=table.raw[0]
  data=@mobile.balance_total
  expect(data).to eq(assdata)
end




