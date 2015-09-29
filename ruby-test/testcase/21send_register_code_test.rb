

class Testregister_send_phone_code<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('register-send-phone-code')
    @url="http://rpc.wangmin.test.zrcaifu.com/register-send-phone-code"
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
      data={"phone"=>"13500000098","token"=>""}
      path='.error'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result=(nil.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的error为null"
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
      jsondata=jsonlist reqbody,path
      result=("手机号码不合法".eql?jsondata)
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
      jsondata=jsonlist reqbody,path
      result=("手机号码不合法".eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的error为手机号码不合法"
      @html.add_to_report(result,test)
    end
  end


end