require_relative '../../pageobject/home_page'
require 'cucumber'

Given /待添加/ do
  @mobile=Home.new(@driver)
  data=@mobile.in_home
  expect("中瑞财富").to eq(data)
end

Given /待添加1/ do |loantype,table|
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


