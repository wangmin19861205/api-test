base_dir = File.dirname(__FILE__)               #工作目录
lib_dir  = File.join(File.dirname(base_dir), "libs/iframe")        #lib包目录
test_dir = File.join(base_dir, "testcase")      #case目录
#将lib包目录添加至系统变量中
$LOAD_PATH.unshift(lib_dir)
#导入unit与gem包
require 'test/unit'
require 'bundler/setup'
require 'watir-webdriver'
Bundler.require(:default)
#将lib包下的文件全部导入
Dir.foreach(lib_dir) do |filename|
  if filename != "." and filename != ".." and filename != "gitpull.rb" and filename != "myappium.rb"
    filename = File.join(lib_dir,"#{filename}")
    require_relative "#{filename}"
  end
end


Test::Unit.at_start do
  inifile=File.open("results/result.html", 'w+')
  inifile.puts('<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <title>Test Report: zrcaifu </title>
      <link rel="stylesheet" type="text/css" href="../classes/css/bluegray.css">
      </head>')
  inifile.close
  $stderr.puts "初始化result"
end


Test::Unit.at_exit do
  driver=Watir::Browser.new :chrome
  driver.window.maximize
  driver.goto "file://#{File.realpath(base_dir)}/results/result.html"
end


exit Test::Unit::AutoRunner.run(true, test_dir)



=begin
待完善
1.测试环境---default与test的api与db配置
2.case的实例变量:@url之类独立到yaml中
3.公共方法需添加对异常的处理
4.复杂http请求：head与cookie,delete与put
5.多格式的返回xml,text等
6.所有验证中的数值转换,BigDecimal需转换为float --完成
7.json解析,json中包含多个列表，列表中包含json，写个公共方法解析
=end
#ruby main.rb -t Testaccount_journals