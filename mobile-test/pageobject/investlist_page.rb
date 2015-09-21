require_relative '../pageobject/pageobject'
require_relative '../pageelement/5myaccount_page'


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

  def in_withdraw
    @driver.find_until(Withdraw_button)
  end

  def in_recharge
    @driver.find_until(Recharge_button)
  end

  def in_investlist
    @driver.find_until(Invest_list)
  end

  def in_journals
    @driver.find_until(Journals_list)
  end

  def in_mybankcard
    @driver.find_until(Bank_card)
  end

  def in_myreward
    @driver.find_until(My_reward)
  end

  def in_invitefriend
    @driver.find_until(Invite_friend)
  end

end




