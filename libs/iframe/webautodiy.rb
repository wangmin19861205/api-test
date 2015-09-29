require 'watir-webdriver'
require_relative '../config/settings'


class Webautodiy

  def initialize
    @setting=Settings.new.URL
    browser=@setting.browser
    @driver=Watir::Browser.new browser.to_sym
    @driver.window.maximize
    return @driver
  end



end

