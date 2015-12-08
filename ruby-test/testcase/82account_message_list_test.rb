


class Testaccount_message_list<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @conn.update("update user_messages set disable = 0,is_read = 0")
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_message_list')
    phone="13500000069"
    url=ENV["rpc"]+"login"
    data={"name"=>phone,"password"=>"123456"}
    path='.token'
    reqbody=httppost(url,data)
    @token=jsonlist reqbody,path
    @user_id=jsonlist reqbody,'.user.id'
    @url=ENV["rpc"]+"account/message/list"
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
    begin
      @html.newTestName('获取消息概览-正常')
      data={"token"=>@token}
      rechargecountsql="select count(id) as conut, message_type  from user_messages where disable = 0 and user_id = '#{@user_id}' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP')  and is_read = 0  and message_type in ('WITHDRAW','RECHARGE')"
      rechargemessagesql1="select id, user_id , message_type , content, is_read ,title , create_time, icon_isok from user_messages where disable = 0 and user_id = '#{@user_id}' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP')  and message_type in ('WITHDRAW','RECHARGE') order by create_time desc limit 1"
      investcountsql="select count(id) as conut, message_type  from user_messages where disable = 0 and user_id = '#{@user_id}' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP')  and is_read = 0  and message_type = 'INVEST'"
      investmessagesql1="select id, user_id , message_type , content, is_read ,title , create_time, icon_isok from user_messages where disable = 0 and user_id = '#{@user_id}' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP')  and message_type ='INVEST' order by create_time desc limit 1"
      path='.messages[1].new_message_count'
      path1='.messages[1].newest_message'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      countsqldata=Resultdiy.new(@conn.sqlquery(investcountsql)).result_to_list
      result1= jsondata == countsqldata[0][:conut]
      jsondata1=jsonlist reqbody,path1
      sqldata=Resultdiy.new(@conn.sqlquery(investmessagesql1)).result_to_list
      result=asskey(jsondata1,sqldata,["id",:id])
      path2='.messages[3].new_message_count'
      path3='.messages[3].newest_message'
      jsondata=jsonlist reqbody,path2
      countsqldata1=Resultdiy.new(@conn.sqlquery(rechargecountsql)).result_to_list
      result2= jsondata == countsqldata1[0][:conut]
      jsondata1=jsonlist reqbody,path3
      sqldata1=Resultdiy.new(@conn.sqlquery(rechargemessagesql1)).result_to_list
      result3=asskey(jsondata1,sqldata1,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查:INVEST消息的统计总数conut'
      @html.add_to_report(result1,test)
      test = '检查关键字:INVEST消息message_id'
      @html.add_to_report(result,test)
      test = '检查:充值提现消息的统计总数conut'
      @html.add_to_report(result2,test)
      test = '检查关键字:充值提现消息message_id'
      @html.add_to_report(result3,test)
    end
  end



  #未完成
  def test_wrong
    begin
      @html.newTestName('获取消息概览-参数为空')
      data={}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata1=jsonlist reqbody,path
      result= "token 失效".eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查error=token 失效'
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong1
    begin
      @html.newTestName('获取消息概览-参数值为空')
      data={"token"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata1=jsonlist reqbody,path
      result= "token 失效".eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查error=token 失效'
      @html.add_to_report(result,test)
    end
  end


end