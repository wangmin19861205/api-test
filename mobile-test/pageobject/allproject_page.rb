require_relative '../pageobject/pageobject'
require_relative '../pageelement/2allproject_page'



class Allproject < PageObject
  def pagetitle
    @driver.find_until(Allproject_title).text
  end

  def switch_newproject
    @driver.find_untils(Tab_buttons)[0].click
  end

  def switch_shortproject
    @driver.find_untils(Tab_buttons)[1].click
  end

  def switch_middleproject
    @driver.find_untils(Tab_buttons)[2].click
  end

  def switch_longproject
    @driver.find_untils(Tab_buttons)[3].click
  end

  def switch_vipproject
    @driver.find_untils(Tab_buttons)[4].click
  end

  def loancard
    text1=@driver.find_untils(Project_annualized_rate).map do |item|
      item.text
    end
    text2=@driver.find_untils(Project_annualized_rate0).map do |item|
      item.text
    end
    text3=@driver.find_untils(Project_invest_date).map do |item|
      item.text
    end
    text4=@driver.find_untils(Project_total_money).map do |item|
      item.text
    end
    text5=@driver.find_untils(Project_progress).map do |item|
      item.text
    end
    text6=@driver.find_untils(Project_name).map do |item|
      item.text
    end
    text7=@driver.find_untils(Project_guarantee_category).map do |item|
      item.text
    end
    text8=@driver.find_untils(Project_payment_type).map do |item|
      item.text
    end
    return text1,text2,text3,text4,text6,text7,text8
  end

  def newloandetail
    text1=@driver.find_until(Newproject_annualized_rate).text
    text2=@driver.find_until(Newproject_annualized_rate0).text
    text3=@driver.find_until(Newproject_invest_date).text
    text4=@driver.find_until(Newproject_invest_date0).text
    text5=@driver.find_until(Newproject_invest_money).text
    text6=@driver.find_until(Newproject_invest_money0).text
    return text1,text2,text3,text4,text5,text6
  end

  def get_invitefriend_text
    return @driver.find_until(Invite_friend_text).text
  end

  def get_invest_button
    return @driver.find_until(Invest_button).text
  end



end
