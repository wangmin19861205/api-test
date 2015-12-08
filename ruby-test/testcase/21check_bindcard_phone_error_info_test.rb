

class Testcheck_bindcard_phone_error_info<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('check-bindcard-phone-error')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    phone="13500000069"
    url=ENV["rpc"]+"login"
    data={"name"=>phone,"password"=>"123456"}
    path='.token'
    reqbody=httppost(url,data)
    @token=jsonlist reqbody,path
    @url=ENV["rpc"]+"mobileapi/check-bindcard-phone-error-info"
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
      @html.newTestName('校验绑卡手机号-正常')
      data={"token"=>@token,"phone"=>"13512345678"}
      path='.error'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result=(nil.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的has_valid为false"
      @html.add_to_report(result,test)
    end
  end

=begin
  #未完成
  def test_wrong
    begin
      @html.newTestName('校验绑卡手机号-参数为空')
      data={}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result=(''.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的error为身份证信息错误"
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong1
    begin
      @html.newTestName('校验绑卡手机号-参数值为空')
      data={"token"=>@token,"idcard_number"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result=(''.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的error为身份证信息错误"
      @html.add_to_report(result,test)
    end
  end
=end

end