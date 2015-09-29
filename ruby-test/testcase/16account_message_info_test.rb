


class Testaccount_message_info<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_message_info')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000069","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
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
    begin
      @html.newTestName('获取消息数量-正常')
      data={"token"=>@token}
      sql="select count(*) as conut from user_messages where disable = false and user_id = '#{@user_id}' and is_read= false and create_time > date_sub(current_date(),INTERVAL 90 day)  and (display_type = 'ALL' or display_type ='APP')  "
      sql1="select count(*) as conut from user_messages where disable = false and user_id = '#{@user_id}' and create_time > date_sub(current_date(),INTERVAL 90 day)  and (display_type = 'ALL' or display_type = 'APP')   "
      path='.info.unread_message_count'
      path1='.info.total_message_count'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      jsondata1=jsonlist reqbody,path1
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
      result= jsondata == sqldata[0][:conut]
      result1= jsondata1 == sqldata1[0][:conut]
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查未读消息的统计总数conut'
      @html.add_to_report(result,test)
      test1 = '检查全部消息的统计总数conut'
      @html.add_to_report(result1,test1)
    end
  end



  #未完成
  def test_wrong
    begin
      @html.newTestName('获取消息数量-参数为空')
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
      @html.newTestName('获取消息数量-参数值为空')
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