require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testhome<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('home')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/home"
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
    @html.newTestName('首页-未登录')
    data={"token"=>""}
    path='.data.loans'
    newpath='.data.new_user_loan'
    newsql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'NEWUSER_PROJECT' order by invest_open_time asc limit 1"
    readysql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type <> 'NEWUSER_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
    opensql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type <> 'NEWUSER_PROJECT' and invest_open_time > now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    newjsondata=jsonlist reqbody,newpath
    newsqldata=Resultdiy.new(@conn.sqlquery(newsql)).result_to_list
    readysqldata=Resultdiy.new(@conn.sqlquery(readysql)).result_to_list
    opensqldata=Resultdiy.new(@conn.sqlquery(opensql)).result_to_list
    sqldata=readysqldata+opensqldata+newsqldata
    alljsondata=jsondata.push(newjsondata)
    test="检查关键字loan_id"
    result=asskey(alljsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right1
    @html.newTestName('首页-已登录,已投资')
    data={"token"=>"#{@token}"}
    path='.data.loans'
    newpath='.data.new_user_loan'
    readysql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type <> 'NEWUSER_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
    opensql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type <> 'NEWUSER_PROJECT' and invest_open_time > now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    readysqldata=Resultdiy.new(@conn.sqlquery(readysql)).result_to_list
    opensqldata=Resultdiy.new(@conn.sqlquery(opensql)).result_to_list
    sqldata=readysqldata+opensqldata
    test="检查json的new_user_loan为空"
    @html.add_to_report((nil.eql?(jsonlist reqbody,newpath)),test)
    test="检查关键字loan_id"
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end



end