

class Testlogout<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('logout')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000069","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/logout"
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
      @html.newTestName('注销-正常')
      data={"token"=>@token}
      path='.success'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result= true.equal?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的success=true'
      @html.add_to_report(result,test)
    end
    end


  #未完成
  def test_wrong
    begin
      @html.newTestName('注销-参数为空')
      data={}
      path='.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result= "缺少token".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的error=缺少token'
      @html.add_to_report(result,test)
    end
    end

  #未完成
  def test_wrong1
    begin
      @html.newTestName('注销-参数值为空')
      data={"token"=>''}
      path='.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result="缺少token".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的error=缺少token'
      @html.add_to_report(result,test)
    end
    end

end