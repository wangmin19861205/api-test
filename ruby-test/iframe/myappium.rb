require 'appium_lib'


class Appium::Driver
  #在appium::driver中添加find_until方法
  def find_until(timeout=30,ele)
    wait=Selenium::WebDriver::Wait.new(:timeout => timeout)
    wait.until do @driver.find_element(ele)
    end
  end

  def find_untils(timeout=30,eles)
    wait=Selenium::WebDriver::Wait.new(:timeout => timeout)
    wait.until do @driver.find_elements(eles)
    end
  end

end



=begin
caps1  =  {caps:       { platformName: 'Android', deviceName: 'HWHol-T',appActivity: '.ui.MainActivity', appPackage: 'com.zrcaifu' },
           appium_lib: { sauce_username: nil, sauce_access_key: nil } ,
           app: "/Users/wangmin/Downloads/com.onektower.tgame_20150818.apk" }
driver = Appium::Driver.new(caps1)
driver.start_driver
driver.set_wait 10
driver.device_is_android?
a={xpath: '//android.widget.Button[contains(@text,"去首页面")]'}
b={xpath: '//android.widget.RadioButton[contains(@text,"我的账户")]'}
p driver.find_element(a).text
#driver.find_until(b).click
#c={start_x: 350, start_y: 150,end_x: 150,end_y: 150,duration: 1}
#driver.swipe(c)
driver.driver_quit
=end

