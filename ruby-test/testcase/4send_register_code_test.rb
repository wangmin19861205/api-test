

class Testregister_send_phone_code<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('register-send-phone-code')
    @url=ENV["rpc"]+"register-send-phone-code"
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
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
      @html.newTestName('注册验证码-正常')
      data={"phone"=>"13500000197","token"=>""}
      path='.error'
      reqbody=httppost(@url,data)
      puts reqbody
      jsondata=jsonlist reqbody,path
      result=(nil.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的error为null"
      @html.add_to_report(result,test)
    end
  end

  def test_right1
    begin
      @html.newTestName('注册验证码-用户已注册')
      data={"phone"=>"13500000069","token"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data)
      puts reqbody
      jsondata=jsonlist reqbody,path
      result=('该手机已注册，请返回直接登录'.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的error为:该手机已注册，请返回直接登录"
      @html.add_to_report(result,test)
    end
  end



  #未完成
  def test_wrong
    begin
      @html.newTestName('注册验证码-参数为空')
      data={}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result=("请输入正确的手机号码".eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的error为手机号码不合法"
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong1
    begin
      @html.newTestName('注册验证码-参数值为空')
      data={"phone"=>"","token"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result=("请输入正确的手机号码".eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的error为手机号码不合法"
      @html.add_to_report(result,test)
    end
  end


end