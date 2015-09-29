base_dir = File.dirname(File.dirname(File.dirname(__FILE__)))             #工作目录
lib_dir  = File.join(File.dirname(base_dir), "libs/iframe")        #lib包目录
pageobject = File.join(base_dir, "pageobject")   #pageobject包目录
#test_dir = File.join(base_dir, "uitestcase")      #case目录


ENV["reportpath"]=File.join(base_dir,"report/")
#将lib,pageobject包目录添加至系统变量中
$LOAD_PATH.unshift(lib_dir)

#导入gem包
require 'bundler/setup'
require 'watir-webdriver'
Bundler.require(:default)

#将lib与page包下的文件全部导入
Dir.foreach(lib_dir) do |filename|
  if filename != "." and filename != ".." and filename != "gitpull.rb"
    filename = File.join(lib_dir,"#{filename}")
    require_relative "#{filename}"
  end
end
Dir.foreach(pageobject) do |filename|
  if filename != "." and filename != ".."
    filename = File.join(pageobject,"#{filename}")
    require_relative "#{filename}"
  end
end




Before do |scenario|
  #clear_redis
  @driver=Mobile.new.open
end

After do |scenario|
  @driver.driver_quit
  if scenario.failed?
    subject = "[Project X] #{scenario.exception.message}"
    end
end

at_exit do
  driver=Watir::Browser.new :chrome
  driver.window.maximize
  driver.goto "file://#{File.realpath(base_dir)}/report/report.html"
end


