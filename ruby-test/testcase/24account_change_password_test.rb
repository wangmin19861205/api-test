


class Testaccount_change_password<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_change_password')
    #获取用户token与user_id
    @phone="13500000069"
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>@phone,"password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
    #获取用户修改密码验证码code
    url1="http://rpc.wangmin.test.zrcaifu.com/account/change-pwd-auth-code"
    data1={"token"=>@token,"phone"=>@phone}
    httppost(url1,data1)
    sql="select content from sms_records where numbers = '#{@phone}' order by id desc limit 1"
    codetext=(Resultdiy.new(@conn.sqlquery(sql)).result_to_list[0])[:content]
    @code=/您正在更改登录密码，请输入验证码(.*)，10分钟内有效/.match(codetext).to_a[1]
    #校验用户修改密码验证码code
    url2="http://rpc.wangmin.test.zrcaifu.com/account/verify-pwd-auth-code"
    data2={"token"=>@token,"phone"=>@phone,"idcard_number"=>"43042119861205001","code"=>@code}
    httppost(url2,data2)
    @url="http://rpc.wangmin.test.zrcaifu.com/account/change-password"
  end


  def teardown
    @conn.update("update users set password = '$2a$10$Ltxt/FYOj7ZD5kTr0XqqBeMYtn7qeiF44svgfBKD1863R4x8JvcmC' where id = '#{@user_id}'  ")
    @conn.close
    @html.finishReport(@report, @test_environment)
  rescue => e
    puts $!
    puts e.backtrace
    @html.finishReport(@report, @test_environment)
  end

  def test_right
    begin
      @html.newTestName('设置新密码-正常')
      data1={"token"=>@token,"phone"=>@phone,"password"=>"1234567"}
      path='.success'
      reqbody=httppost(@url,data1)
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
      @html.newTestName('设置新密码-参数为空')
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
      @html.newTestName('设置新密码-参数值为空')
      data1={"token"=>'',"phone"=>'',"password"=>""}
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