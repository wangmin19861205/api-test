require_relative '../pageelement/4register_page'
require_relative '../pageobject/pageobject'

class Register < PageObject
  def pagetitle
    @driver.find_until(Register_Page_title).text
  end

  def register username,password,code
      a=@driver.find_until(Username_text)
      a.send_keys(username)
      #@driver.find_until(Get_code).click
      b=@driver.find_until(Verification_code)
      b.send_keys(code)
      c=@driver.find_until(Password_text)
      c.send_keys(password)
      @driver.find_until(Register_Page_Cancel_button).click
  end

  def to_login
    @driver.find_until(Login_link)
  end

  def swipe x,y,x1,y1,duration
    @driver.press x: x, y: y
    @driver.wait(duration) if duration
    @driver.move_to x: x1, y: y1
    @driver.swipe()
  end

end