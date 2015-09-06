require 'appium_lib'
require_relative '../conf/settings'


class Browser
  def initialize
    @setting=SettingsMOBILE.new
    @siteurl = @setting.URL.site
    @adminurl = @setting.URL.admin
    @driver = Appium::Driver.new
    platformName=@setting.platformName
    deviceName=@setting.deviceName
    appActivity=@setting.appActivity
    appPackage=@setting.appPackage
    @caps = {caps:       { platformName: platformName, deviceName: deviceName,appActivity: appActivity, appPackage: appPackage },
            appium_lib: { sauce_username: nil, sauce_access_key: nil } }
  end

  def

  end
end