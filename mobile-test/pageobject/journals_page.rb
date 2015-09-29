require_relative '../pageobject/pageobject'
require_relative '../pageelement/9journals'


class Journals < PageObject
  def pagetitle
    @driver.find_until(Journals_Page_title).text
  end

  def switch_all_tab
    @driver.find_untils(Journals_AllCategory_taps)[0].click
  end

  def switch_doing_tab
    @driver.find_untils(Journals_doing_taps)[1].click
  end

  def switch_type_tab
    @driver.find_untils(Journals_type_taps)[2].click
  end

  def journals_record
    text1=@driver.find_untils(Journals_name).map do |item|
      item.text
    end
    text2=@driver.find_untils(Journals_amounts).map do |item|
      item.text
    end
    text3=@driver.find_untils(Journals_status).map do |item|
      item.text
    end
    return text1,text2,text3
  end


end




