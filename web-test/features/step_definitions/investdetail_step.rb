require_relative '../../pageobject/invest_detail_page'


Given /^投资(.*)/ do |money|
  webapp=Investdetail.new(@driver)
  webapp.invest money
end



