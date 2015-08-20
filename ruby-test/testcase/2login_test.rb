require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testlogin<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('userlogin')
    @url="http://rpc.wangmin.test.zrcaifu.com/login"
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
    @html.newTestName('用户登录-正常')
    data={"name"=>"13500000045","password"=>"123456"}
    sql="select * from users where id = '2898945'"
    path='.data.user'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字user_id'
    @html.add_to_report((asskey jsondata,sqldata,["id",:id]),test)
    test1 = '检查json中的error为空'
    @html.add_to_report((nil.equal?(jsonlist reqbody,'.data.error')),test1)
  end

  def test_wrong
    @html.newTestName('用户登录-密码错误')
    data={"name"=>"13500000045","password"=>"123451"}
    path='.data.error.code'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    p jsondata
    test = '检查json中的error为10101'
    @html.add_to_report((10101.equal?jsondata),test)
  end

  def test_wrong1
    @html.newTestName('用户登录-用户不存在')
    data={"name"=>"1350000004","password"=>"123456"}
    path='.data.error.code'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    test = '检查json中的error为10100'
    @html.add_to_report((10100.equal?jsondata),test)
  end

end