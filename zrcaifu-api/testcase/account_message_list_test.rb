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
    data1={"token"=>@token}
    sql1="select id, user_id , message_type , content, is_read ,title , create_time, icon_isok from user_messages where disable = 0 and user_id = '2898945' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'MOBILE') order by create_time desc "
    path='.data[].newest_message'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字message_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

end