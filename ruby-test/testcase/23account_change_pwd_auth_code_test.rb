


class Testaccount_change_pwd_auth_code<Test::Unit::TestCase
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
    p reqbody
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/change-pwd-auth-code"
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
      @html.newTestName('获取修改密码验证码-正常')
      data1={"token"=>@token,"phone"=>@phone}
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
      @html.newTestName('获取修改密码验证码-参数为空')
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
      @html.newTestName('获取修改密码验证码-参数值为空')
      data1={"token"=>"","ids"=>""}
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


end