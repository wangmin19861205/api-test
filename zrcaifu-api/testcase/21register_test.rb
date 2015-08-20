require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testregister<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('register')
    @url="http://rpc.wangmin.test.zrcaifu.com/register"
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
    @html.newTestName('用户注册-正常')
    data={"phone"=>"13500000099","auth_code"=>"13500000099","password"=>"13500000099","refer_phone"=>"13500000099"}
    sql="select * from `sms_records` where `numbers` = '13500000099' order by id limit 1"
    path='.data.user'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    test="检查关键字user_id"
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end




end