


class Testaccount_message_list<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @conn.update("update user_messages set disable = 0,is_read = 0")
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

  def test_right
    @html.newTestName('获取消息概览-正常')
    data={"token"=>@token}
    rechargecountsql="select count(id) as conut, message_type  from user_messages where disable = 0 and user_id = '2898945' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'MOBILE')  and is_read = 0  and message_type in ('WITHDRAW','RECHARGE')"
    rechargemessagesql1="select id, user_id , message_type , content, is_read ,title , create_time, icon_isok from user_messages where disable = 0 and user_id = '2898945' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'MOBILE')  and message_type in ('WITHDRAW','RECHARGE') order by create_time desc limit 1"
    investcountsql="select count(id) as conut, message_type  from user_messages where disable = 0 and user_id = '2898945' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'MOBILE')  and is_read = 0  and message_type = 'INVEST'"
    investmessagesql1="select id, user_id , message_type , content, is_read ,title , create_time, icon_isok from user_messages where disable = 0 and user_id = '2898945' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'MOBILE')  and message_type ='INVEST' order by create_time desc limit 1"
    path='.data[1].new_message_count'
    path1='.data[1].newest_message'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    countsqldata=Resultdiy.new(@conn.sqlquery(investcountsql)).result_to_list
    test = '检查:INVEST消息的统计总数conut'
    @html.add_to_report(jsondata == countsqldata[0][:conut],test)
    jsondata1=jsonlist reqbody,path1
    sqldata=Resultdiy.new(@conn.sqlquery(investmessagesql1)).result_to_list
    test = '检查关键字:INVEST消息message_id'
    result=asskey(jsondata1,sqldata,["id",:id])
    @html.add_to_report(result,test)

    path='.data[3].new_message_count'
    path1='.data[3].newest_message'
    jsondata=jsonlist reqbody,path
    countsqldata=Resultdiy.new(@conn.sqlquery(rechargecountsql)).result_to_list
    test = '检查:充值提现消息的统计总数conut'
    @html.add_to_report(jsondata == countsqldata[0][:conut],test)
    jsondata1=jsonlist reqbody,path1
    sqldata=Resultdiy.new(@conn.sqlquery(rechargemessagesql1)).result_to_list
    test = '检查关键字:充值提现消息message_id'
    result=asskey(jsondata1,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

end