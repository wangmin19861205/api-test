require 'watir-webdriver/wait'

class PageObject

  def initialize driver
    @driver=driver
    return @driver
  end

  def refresh
    @driver.refresh
  end

  def wait_until (timeout=10, &block)
    Watir::Wait.until(timeout, &block)
  end


  #可以添加更多页面共用方法
end


