require_relative '../pageobject/pageobject'
require_relative '../pageelement/3login_page'



class Login < PageObject
  def pagetitle
    @driver.find_until(Login_title).text
  end

  def login(username,password)
    a=@driver.find_until(Login_Username_text)
    a.send_keys(username)
    b=@driver.find_until(Login_Password_text)
    b.send_keys(password)
    @driver.find_until(Login_confirm_button).click
  end

  def to_register
    @driver.find_until(Register_button).click
  end

end




