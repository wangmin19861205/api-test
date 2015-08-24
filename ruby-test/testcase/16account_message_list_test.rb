require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testaccount_message_list<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_message_list')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/message/list"
  end

  def teardown
    @conn.close
    @html.finishReport(@report, @test_environment)
  rescue => e
    puts $!
    puts e.backtrace
    @html.finishReport(@report, @test_environment)
  end

#未完成
  def test_right
    @html.newTestName('获取消息概览-正常')
    data={"token"=>@token}
    countsql="select count(id) as conut, message_type  from user_messages where disable = 0 and user_id = '2898945' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'MOBILE')  and is_read = 0  and message_type = 'INVEST'"
    messagesql1="select id, user_id , message_type , content, is_read ,title , create_time, icon_isok from user_messages where disable = 0 and user_id = '2898945' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'MOBILE')  and message_type ='INVEST' order by create_time desc limit 1"
    path='.data[2].new_message_count'
    path1='.data[2].newest_message'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    countsqldata=Resultdiy.new(@conn.sqlquery(countsql)).result_to_list
    test = '检查投资消息的统计总数conut'
    @html.add_to_report(jsondata == countsqldata[0][:conut],test)
    jsondata1=jsonlist reqbody,path1
    sqldata=Resultdiy.new(@conn.sqlquery(messagesql1)).result_to_list
    test = '检查关键字:投资消息message_id'
    result=asskey(jsondata1,sqldata,["id",:id])
    @html.add_to_report(result,test)

  end

end