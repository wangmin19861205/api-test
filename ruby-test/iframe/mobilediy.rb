require 'appium_lib'
require_relative '../conf/settings'


class Mobile
  def initialize
    @setting=SettingsMOBILE.new.MOBILE
    platformName=@setting.platformName
    deviceName=@setting.deviceName
    appActivity=@setting.appActivity
    appPackage=@setting.appPackage
    @caps = {caps:       { platformName: platformName, deviceName: deviceName,appActivity: appActivity, appPackage: appPackage },
            appium_lib: { sauce_username: nil, sauce_access_key: nil } }
    @driver=Appium::Driver.new(@caps)
  end

  def open
    @driver.start_driver
    @driver.set_wait 30
    return @driver
  end

end

