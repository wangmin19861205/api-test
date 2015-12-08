

class Testuser_check_idcard_number_exist<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('user-check-idcard-number-exist')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    phone="13700000012"
    url=ENV["rpc"]+"login"
    data={"name"=>phone,"password"=>"123456"}
    path='.token'
    reqbody=httppost(url,data)
    @token=jsonlist reqbody,path
    @url=ENV["rpc"]+"user/check-idcard-number-exist"
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
      @html.newTestName('校验身份证号码有效-库中不存在')
      data={"token"=>@token,"idcard_number"=>"210502198412020944"}
      path='.has_existed'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result=(false.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的has_valid为false"
      @html.add_to_report(result,test)
    end
  end

  def test_right1
    begin
      @html.newTestName('开户校验身份证号码有效-库中已存在')
      data={"token"=>@token,"idcard_number"=>"43042119861205001"}
      path='.has_existed'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result=(true.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的has_valid为false"
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong
    begin
      @html.newTestName('开户校验身份证号码有效-参数为空')
      data={}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result=('身份证信息错误'.eql?jsondata)
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
      @html.newTestName('开户校验身份证号码有效-参数值为空')
      data={"token"=>@token,"idcard_number"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result=('身份证信息错误'.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的error为身份证信息错误"
      @html.add_to_report(result,test)
    end
  end
end