


class Testaccount_readUserMesssageByIds<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @conn.update("update user_messages set disable = 0,is_read = 0")
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('readUserMesssageByIds')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000069","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
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
    begin
      @html.newTestName('ID读取消息-单个id')
      data1={"token"=>@token,"ids"=>"481"}
      sql1="select is_read from user_messages where disable =0  and user_id = '#{@user_id}' and id in (481)"
      path='.success'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
      result = TRUE == jsondata1
      result1= asssqllist(sqldata1,:is_read,true)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字success=true'
      @html.add_to_report(result,test)
      test = '验证数据库sqldata中关键字is_read=true'
      @html.add_to_report(result1,test)
    end
  end


  #未完成
  def test_wrong
    begin
      @html.newTestName('ID读取消息-参数为空')
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
      @html.newTestName('ID读取消息-参数值为空')
      data1={"token"=>"","ids"=>""}
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