base_dir = File.expand_path(File.join(File.dirname(__FILE__)))
lib_dir  = File.join(base_dir, "iframe")
test_dir = File.join(base_dir, "testcase")

$LOAD_PATH.unshift(lib_dir)
require 'test/unit'

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
exit Test::Unit::AutoRunner.run(true, test_dir)


=begin
待完善
1.测试环境---default与test的api与db配置
2.case的实例变量:@url之类独立到yaml中
3.公共方法需添加对异常的处理
4.复杂http请求：head与cookie,delete与put
5.多格式的返回xml,text等
6.所有验证中的数值转换,BigDecimal需转换为float
7.json解析,json中包含多个列表，列表中包含json，写个公共方法解析
=end
#ruby main.rb -t Testaccount_journals