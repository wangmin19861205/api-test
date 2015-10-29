


class Testaccount_verify_pwd_auth_code<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_change-password')
    @phone="13500000069"
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>@phone,"password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
    url1="http://rpc.wangmin.test.zrcaifu.com/account/change-pwd-auth-code"
    data1={"token"=>@token,"phone"=>@phone}
    httppost(url1,data1)
    sql="select content from sms_records where numbers = '#{@phone}' order by id desc limit 1"
    codetext=(Resultdiy.new(@conn.sqlquery(sql)).result_to_list[0])[:content]
    @code=/您正在更改登录密码，请输入验证码(.*)，10分钟内有效/.match(codetext).to_a[1]
    @url="http://rpc.wangmin.test.zrcaifu.com/account/verify-pwd-auth-code"
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
      @html.newTestName('校验短信验证码-正常')
      data1={"token"=>@token,"phone"=>@phone,"idcard_number"=>"43042119861205001","code"=>@code}
      path='.success'
      reqbody=httppost(@url,data1)
      p reqbody
      jsondata1=jsonlist reqbody,path
      result = TRUE == jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字success=true'
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong
    begin
      @html.newTestName('校验短信验证码-参数为空')
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
      @html.newTestName('校验短信验证码-参数值为空')
      data1={"token"=>'',"phone"=>'',"idcard_number"=>"","code"=>''}
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