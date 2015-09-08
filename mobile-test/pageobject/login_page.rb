require_relative '../pageobject/pageobject'
require_relative '../pageelement/login_page'


class Login < PageObject
  def pagetitle
    return @driver.find_until(Login_title).text
  end

  def login(username,password)
    @driver.find_until(Username_text).send_keys(username)
    @driver.find_until(Password_text).send_keys(password)
    @driver.find_until(Login_confirm_button).click
  end

end




