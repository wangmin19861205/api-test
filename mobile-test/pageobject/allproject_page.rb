require_relative '../pageobject/pageobject'
require_relative '../pageelement/allproject_page'


class Allproject < PageObject
  def pagetitle
    @driver.find_until(Page_title).text
  end



end




