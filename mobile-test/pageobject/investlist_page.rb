require_relative '../pageobject/pageobject'
require_relative '../pageelement/8investlist'


class Investlist < PageObject
  def pagetitle
    @driver.find_until(Investlist_Page_title).text
  end

  def switch_repay
    @driver.find_untils(Category_taps)[1].click
  end

  def switch_no_repay
    @driver.find_untils(Category_taps)[0].click
  end

  def invest_projects
    text1=@driver.find_untils(Repay_dayss).map do |item|
      item.text
    end
    text3=@driver.find_untils(Invest_ammouts).map do |item|
      item.text
    end
    text4=@driver.find_untils(Invest_received_amounts).map do |item|
      item.text
    end
    text2=@driver.find_untils(Invest_unreceived_amounts).map do |item|
      item.text
    end
    return text1,text2,text3,text4
  end


end




