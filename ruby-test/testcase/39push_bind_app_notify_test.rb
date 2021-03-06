


class Testbind_app_notify<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('bind_app_notify')
    phone="13500000069"
    url=ENV["rpc"]+"login"
    data={"name"=>phone,"password"=>"123456"}
    path='.token'
    reqbody=httppost(url,data)
    @token=jsonlist reqbody,path
    @url=ENV["rpc"]+"user/bind-app-notify"
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
      @html.newTestName('推送-绑定设备:正常')
      data={"token"=>@token,"register_id"=>"0907e7015ef"}
      path='.success'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result=true.equal?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字success=true'
      @html.add_to_report(result,test)
      end
  end


  def test_right1
    begin
      @html.newTestName('推送-绑定设备:参数为空')
      data={}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result='token 失效'.equal?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字msg=token 失效'
      @html.add_to_report(result,test)
    end
  end

  def test_right2
    begin
      @html.newTestName('推送-绑定设备:参数值为空')
      data={"token"=>'',"register_id"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result='token 失效'.equal?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字msg=token 失效'
      @html.add_to_report(result,test)
    end
  end


  #未完成，需添加新手项目为空，只有还款状态的case
end