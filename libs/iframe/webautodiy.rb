require 'watir-webdriver'
require_relative '../conf/settings'


class Webautodiy

  def initialize
    @setting=SettingsWEB.new.URL
    browser=@setting.browser
    @driver=Watir::Browser.new browser.to_sym
    @driver.window.maximize
  end

  def open url
    if url == "site"
      @driver.goto @setting.site
    elsif url == "admin"
      @driver.goto @setting.admin
    else
      @driver.goto url
    end
    return @driver
  end


end

