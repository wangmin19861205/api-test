require_relative '../pageobject/pageobject'
require_relative '../pageelement/1login_page'



class Loginpage < PageObject

  def login_dialog username,password
    @driver.div(Login_dialog_frame).when_present
    @driver.text_field(Login_dialog_username_text).when_present.set(username)
    #@driver.execute_script("document.getElementsByClassName('#{Login_dialog_username_js}')[1].value=#{username}")
    @driver.text_field(Login_dialog_password_text).when_present.set(password)
    #@driver.execute_script("document.getElementsByClassName('#{Login_dialog_password_js}')[1].value=#{password}")
    @driver.button(Login_dialog_login_button).when_present.click
    #@driver.execute_script("document.getElementsByClassName('#{Login_dialog_login_buttonjs}')[1].click()")
  end


  def login_page username,password
    @driver.text_field(Login_username_text).when_present.set(username)
    @driver.text_field(Login_password_text).when_present.set(password)
    @driver.button(Login_login_button).when_present.click
  end




end
