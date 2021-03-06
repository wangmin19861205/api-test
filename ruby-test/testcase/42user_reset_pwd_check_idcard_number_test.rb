


class Testuser_reset_pwd_check_idcard_number<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('user_reset_pwd_check_idcard_number')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    @phone="13500000069"
    sql="select * from users where secure_phone = '13500000069' limit 1"
    @idcard_number=(Resultdiy.new(@conn.sqlquery(sql)).result_to_list[0])[:idcard_number]
    url1=ENV["rpc"]+"user/reset-password-send-auth-code"
    data1={"phone"=>@phone}
    reqbody=httppost(url1,data1)
    path=".token"
    @token=jsonlist reqbody,path
    sql="select content from sms_records where numbers = '#{@phone}' order by id desc limit 1"
    codetext=(Resultdiy.new(@conn.sqlquery(sql)).result_to_list[0])[:content]
    @code=/您正在更改登录密码，请输入验证码(.*)，10分钟内有效/.match(codetext).to_a[1]
    url2=ENV["rpc"]+"user/verify-reset-pwd-auth-code"
    data2={"token"=>@token,"code"=>@code}
    httppost(url2,data2)
    @url=ENV["rpc"]+"user/reset-pwd-check-idcard-number"
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
      @html.newTestName('校验用户身份证-正常')
      data1={"token"=>@token,"idcard_number"=>@idcard_number}
      path='.error'
      reqbody=httppost(@url,data1)
      p reqbody
      jsondata1=jsonlist reqbody,path
      result = nil == jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字success=true'
      @html.add_to_report(result,test)
    end
  end

=begin
  #未完成
  def test_wrong
    begin
      @html.newTestName('校验用户身份证-参数为空')
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
      @html.newTestName('校验用户身份证-参数值为空')
      data1={"token"=>'',"idcard_number"=>''}
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
=end

end