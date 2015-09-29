require_relative '../pageobject/pageobject'
require_relative '../pageelement/3register_page'



class Registerpage < PageObject

  def register
    @driver.text_field(Register_username_text).when_present.set("13500000081")
    @driver.text_field(Register_password_text).when_present.set("123456")
    @driver.text_field(Register_password1_text).when_present.set("123456")
    @driver.text_field(Register_code_button).when_present.click
    code=Sessiondiy.rui(@driver,"注册")
    puts "code~~~~~~~"
    puts code
    @driver.text_field(Register_code_text).when_present.set(code)
    sleep 10
  end





end
