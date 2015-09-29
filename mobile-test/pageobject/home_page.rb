require_relative '../pageobject/pageobject'
require_relative '../pageelement/1home_page'


class Home < PageObject
  def in_homepage
    @driver.find_until(To_home_link).click
    return @driver.find_until(Home_title).text
  end

  def in_home
    @driver.find_until(To_home_button).click
  end

  def in_account
    @driver.find_until(To_account_button).click
  end

  def in_allproject
    @driver.find_until(To_allproject_button).click
  end

  def in_myset
    @driver.find_until(To_myset_button).click
  end

  def in_message
    @driver.find_until(To_Message_button).click
  end

  def loancard
    text1=@driver.find_untils(Annualized_rate).map do |item|
      item.text
    end
    text3=@driver.find_untils(Invest_date).map do |item|
      item.text
    end
    text4=@driver.find_untils(Min_money).map do |item|
      item.text
    end
    text2=@driver.find_untils(Annualized_rate0).map do |item|
      item.text
    end
    return text1,text2,text3,text4
  end

  def newloancard
    text1=[].push @driver.find_until(Newloan_Annualized_rate).text
    text2=[].push @driver.find_until(Newloan_Annualized_rate0).text
    text3=[].push @driver.find_until(Newloan_invest_date).text
    text4=[].push @driver.find_until(Newloan_min_money).text
    return text1,text2,text3,text4
  end

  def message
    @driver.find_until(Message).text
  end

end




