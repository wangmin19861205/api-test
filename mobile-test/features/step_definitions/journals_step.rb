
Given /验证交易明细页面title/ do
  mobile=Journals.new(@driver)
  data=mobile.pagetitle
  expect(data).to eq("交易明细")
end

Given /切换到全部交易明细tab/ do
  mobile=Journals.new(@driver)
  mobile.switch_all_tab
end

Given /切换到处理中的交易明细tab/ do
  mobile=Journals.new(@driver)
  mobile.switch_doing_tab
end


Given /验证交易明细的记录数据:/ do |table|
  mobile=Journals.new(@driver)
  assdata=[]
  table.raw.each do |item|
    item.delete('')
    assdata.push item
  end
  data=mobile.journals_record
  expect(data).to eq(assdata)
end




