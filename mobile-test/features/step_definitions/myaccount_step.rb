
Given /验证我的账户页面title/ do
  mobile=Myaccount.new(@driver)
  data=mobile.pagetitle
  expect(data).to eq("我的账户")
end

Given /验证我的资产:/ do |table|
  mobile=Myaccount.new(@driver)
  assdata=table.raw[0]
  data=mobile.balance_total
  expect(data).to eq(assdata)
end

Given /进入提现页面/ do
  mobile=Myaccount.new(@driver)
  mobile.in_withdraw
end

Given /进入充值页面/ do
  mobile=Myaccount.new(@driver)
  mobile.in_recharge
end

Given /进入投资记录页面/ do
  mobile=Myaccount.new(@driver)
  mobile.in_investlist
end

Given /进入交易明细页面/ do
  mobile=Myaccount.new(@driver)
  mobile.in_journals
end

Given /进入我的银行卡页面/ do
  mobile=Myaccount.new(@driver)
  mobile.in_mybankcard
end

Given /进入我的奖励页面/ do
  mobile=Myaccount.new(@driver)
  mobile.in_myreward
end

Given /进入邀请好友页面/ do
  mobile=Myaccount.new(@driver)
  mobile.in_invitefriend
end




