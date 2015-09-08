


class Testaccount_message_unreadcount<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_message_unreadcount')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/message/unread-count"
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
    @html.newTestName('获取未读消息数量-正常')
    data={"token"=>@token}
    sql="select count(*) as conut from user_messages where disable = false and user_id = '2898945' and is_read= false and create_time > date_sub(current_date(),INTERVAL 90 day)  and (display_type = 'ALL' or display_type ='MOBILE')  "
    path='.data.unread_count'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查消息的统计总数conut'
    @html.add_to_report(jsondata == sqldata[0][:conut],test)
  end

end