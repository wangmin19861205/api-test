require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testaccount_deleteUserMesssageByIds<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @conn.update("update user_messages set disable = 0,is_read = 0")
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('deleteUserMesssageByIds')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/message/deleteUserMesssageByIds"
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
    @html.newTestName('ID删除消息-单个ID')
    data1={"token"=>@token,"ids"=>"480"}
    sql1="select disable from user_messages where id ='480'"
    path='.data.success'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    test = '检查关键字success=true'
    @html.add_to_report((true.eql?jsondata1),test)
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字disable=true'
    @html.add_to_report(asssqllist(sqldata1,:disable,true),test)
  end


end