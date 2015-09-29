require_relative '../pageobject/pageobject'
require_relative '../pageelement/3invest_detail_page'



class Investdetail < PageObject

  def invest money
    @driver.text_field(Investdetail_amount_text).when_present.set(money)
    @driver.a(Investdetail_confirm_button).when_present.click
  end


end
