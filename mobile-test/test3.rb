require 'appium_lib'




@caps = {caps:       { platformName: 'Android', deviceName: 'HWHol-T',appActivity: '.ui.MainActivity', appPackage: 'com.zrcaifu' },
         appium_lib: { sauce_username: nil, sauce_access_key: nil } }
@driver=Appium::Driver.new(@caps)

@driver.start_driver