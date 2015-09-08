require_relative '../pageobject/pageobject'
require_relative '../pageelement/myaccount_page'


class Myaccount < PageObject
  def pagetitle
    @driver.find_until(Myaccount_title).text
  end

  def balance_total
    text1=@driver.find_until(Balance_total).text
    text2=@driver.find_until(Receivable_interest).text
    text3=@driver.find_until(Accumulate_interest).text
    text4=@driver.find_until(Available_money).text
    text5=@driver.find_until(Available_reward).text
    return text1,text2,text3,text4,text5
  end

end




