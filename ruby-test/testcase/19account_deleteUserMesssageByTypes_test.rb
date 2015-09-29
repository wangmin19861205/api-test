


class Testaccount_deleteUserMesssageByTypes<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @conn.update("update user_messages set disable = 0,is_read = 0")
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('deleteUserMesssageByTypes')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000069","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/message/deleteUserMesssageByTypes"
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
      @html.newTestName('类型删除消息-还款')
      data1={"token"=>@token,"types"=>"REPAY"}
      sql1="select disable from user_messages WHERE user_id = '#{@user_id}' and (display_type = 'APP' or display_type ='ALL') and message_type in ('REPAY')"
      path='.success'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      result= true.eql?jsondata1
      sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
      result1= asssqllist(sqldata1,:disable,true)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字success=true'
      @html.add_to_report(result,test)
      test = '验证数据库sqldata中关键字=true'
      @html.add_to_report(result1,test)
    end
  end


  #未完成
  def test_wrong
    begin
      @html.newTestName('类型删除消息-参数为空')
      data1={}
      path='.error.msg'
      reqbody=httppost(@url,data1)
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
      @html.newTestName('类型删除消息-参数值为空')
      data1={"token"=>"","types"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data1)
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