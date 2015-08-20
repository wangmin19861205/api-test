require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testsend_register_code<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('send_register_code')
    @url="http://rpc.wangmin.test.zrcaifu.com/send_register_code"
  end

  def teardown
    @conn.close
    @html.finishReport(@report, @test_environment)
  rescue => e
    puts $!
    puts e.backtrace
    @html.finishReport(@report, @test_environment)
  end

  def test_right
    @html.newTestName('注册验证码-正常')
    data={"phone"=>"13500000099"}
    path='.data.success'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    test="检查json的success为TRUE"
    result=(true.eql?jsondata)
    @html.add_to_report(result,test)
  end


end