require 'appium_lib'


class Appium::Driver
  #在appium::driver中添加find_until方法
  def find_until(timeout=10,ele)
    wait=Selenium::WebDriver::Wait.new(:timeout => timeout)
    wait.until do @driver.find_element(ele)
    end
  end

  def find_untils(timeout=10,eles)
    wait=Selenium::WebDriver::Wait.new(:timeout => timeout)
    wait.until do @driver.find_elements(eles)
    end
  end

end





=begin
require 'appium_lib/device/touch_actions'
include Appium
require_relative '../../mobile-test/pageelement/4register_page'
caps1  =  {caps:       { platformName: 'Android', deviceName: 'HWHol-T',appActivity: '.ui.MainActivity', appPackage: 'com.zrcaifu' },
           appium_lib: { sauce_username: nil, sauce_access_key: nil } }
driver = Appium::Driver.new(caps1)
driver.start_driver
driver.set_wait 10
driver.device_is_android?
sleep 3
driver.press_keycode(4)
#a={xpath: '//android.widget.Button[contains(@index,1)]'}
#b={id: 'com.zrcaifu:id/bottom_bar_mine'}
#c={id: 'com.zrcaifu:id/login_activity_phone_num'}
#c={id: 'com.zrcaifu:id/login_page_register'}
#d={id: 'com.zrcaifu:id/bottom_bar_all'}
#driver.find_until(a).click
#driver.find_until(b).click
#driver.find_until(c).click
#c={start_x: 350, start_y: 350,end_x: 75,end_y: 350,duration: 100}
#driver.swipe c
#driver.execute_script 'mobile: press', :x=> 250,:y=> 420
#driver.find_until(b).click
#driver.find_until(c).click
#a=driver.find_until(c)
#a.send_keys('13500000098')
#driver.find_until(Verification_code).send_keys('1234')
#driver.find_until(Password_text).send_keys('123456')
#driver.hide_keyboard
#driver.find_until(Confirm_button).click
#sleep 3
#cc={start_x: 25, start_y: 790,end_x: 250,end_y: 790,duration: 5000}
#driver.swipe cc
#driver.swipe c
driver.driver_quit
=end