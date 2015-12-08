


class Testuser_reset_password_send_auth_code<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('user_reset_password_send_auth_code')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    @phone="13500000069"
    @url=ENV["rpc"]+"user/reset-password-send-auth-code"
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
      @html.newTestName('获取重置密码验证码-正常')
      data1={"phone"=>@phone}
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

  def test_right1
    begin
      @html.newTestName('获取重置密码验证码-用户不存在')
      phone='13655559999'
      data1={"phone"=>phone}
      path='.error.msg'
      reqbody=httppost(@url,data1)
      p reqbody
      jsondata1=jsonlist reqbody,path
      result = '用户不存在'.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字success=true'
      @html.add_to_report(result,test)
    end
  end


  def test_right2
    begin
      @html.newTestName('获取重置密码验证码-手机格式错误')
      phone='136555999'
      data1={"phone"=>phone}
      path='.error.msg'
      reqbody=httppost(@url,data1)
      p reqbody
      jsondata1=jsonlist reqbody,path
      result = '请输入正确的手机号'.eql?jsondata1
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
      @html.newTestName('获取重置密码验证码-参数为空')
      data1={}
      path='.error.msg'
      reqbody=httppost(@url,data1)
      p reqbody
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
      @html.newTestName('获取重置密码验证码-参数值为空')
      data1={"phone"=>''}
      path='.error.msg'
      reqbody=httppost(@url,data1)
      p reqbody
      jsondata1=jsonlist reqbody,path
      result= "".eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查error='
      @html.add_to_report(result,test)
    end
  end
=end

end