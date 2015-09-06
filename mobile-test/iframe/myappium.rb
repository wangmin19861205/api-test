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



caps1  =  {caps:       { platformName: 'Android', deviceName: 'HWHol-T',appActivity: '.ui.MainActivity', appPackage: 'com.zrcaifu' },
           appium_lib: { sauce_username: nil, sauce_access_key: nil } }
driver = Appium::Driver.new(caps1)
driver.start_driver
driver.set_wait 10
driver.device_is_android?
a={xpath: '//*[@resource-id="com.zrcaifu:id/toLogin"]'}
b1={xpath: "//android.widget.TextView[contains(@resource-id,'com.zrcaifu:id/percent_num')]"}
driver.find_until(a).click
#p driver.find_element(b1).text
#p driver._resource_id(b1,3).text
sleep 3
p driver.source
#p driver.find_until(b1).text
#driver.find_element(b).text
#driver.find_until(b).click
#c={start_x: 350, start_y: 150,end_x: 150,end_y: 150,duration: 1}
#driver.swipe(c)
driver.driver_quit




