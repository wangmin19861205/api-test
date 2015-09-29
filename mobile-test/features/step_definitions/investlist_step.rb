
Given /验证投资记录页面title/ do
  mobile=Investlist.new(@driver)
  data=mobile.pagetitle
  expect(data).to eq("投资记录")
end

Given /切换到未还款项目tab/ do
  mobile=Investlist.new(@driver)
  mobile.switch_no_repay
end

Given /切换到还款项目tab/ do
  mobile=Investlist.new(@driver)
  mobile.switch_repay
end

Given /验证投资记录项目数据:/ do |table|
  mobile=Investlist.new(@driver)
  assdata=table.raw
  data=mobile.invest_projects
  expect(data).to eq(assdata)
end




