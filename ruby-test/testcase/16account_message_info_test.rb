


class Testaccount_message_info<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_message_info')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/message/info"
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
    @html.newTestName('获取消息数量-正常')
    data={"token"=>@token}
    sql="select count(*) as conut from user_messages where disable = false and user_id = '2898945' and is_read= false and create_time > date_sub(current_date(),INTERVAL 90 day)  and (display_type = 'ALL' or display_type ='MOBILE')  "
    sql1="select count(*) as conut from user_messages where disable = false and user_id = '2898945' and create_time > date_sub(current_date(),INTERVAL 90 day)  and (display_type = 'ALL' or display_type = 'APP')   "
    path='.data.unread_message_count'
    path1='.data.total_message_count'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    jsondata1=jsonlist reqbody,path1
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查未读消息的统计总数conut'
    @html.add_to_report(jsondata == sqldata[0][:conut],test)
    test1 = '检查全部消息的统计总数conut'
    @html.add_to_report(jsondata1 == sqldata1[0][:conut],test1)

  end

end