require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testaccount_readUserMesssageByIds<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @conn.update("update user_messages set disable = 0,is_read = 0")
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('readUserMesssageByIds')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/message/readUserMesssageByIds"
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
    @html.newTestName('ID读取消息-单个id')
    data1={"token"=>@token,"ids"=>"481"}
    sql1="select is_read from user_messages where disable =0  and user_id = '2898945' and id in (481)"
    path='.data.success'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    test = '检查关键字success=true'
    @html.add_to_report((TRUE == jsondata1),test)
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字is_read=true'
    @html.add_to_report(asssqllist(sqldata1,:is_read,true),test)
  end


end