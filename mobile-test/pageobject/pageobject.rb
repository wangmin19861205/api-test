


class PageObject

  def initialize driver
    @driver=driver
  end

  def url
    @driver.server_url
  end

  #可以添加更多页面共用方法
end


