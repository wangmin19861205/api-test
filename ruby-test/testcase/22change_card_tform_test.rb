##########


class Testchange_card_tform<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('bindcard-tform')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    @url=ENV["rpc"]+"mobileapitest/change-card"
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
      @html.newTestName('更换绑卡-正常')
      phone="13600000018"
      url=ENV["rpc"]+"login"
      data={"name"=>"#{phone}","password"=>"123456"}
      reqbody= httppost(url,data)
      token=jsonlist reqbody,'.token'
      data={"token"=>"#{token}","bankname"=>"中国工商银行","cardno"=>"6222020200040016236","province"=>"北京","city"=>"北京"}
      path='.error'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result=nil.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end

  def test_right1
    begin
      @html.newTestName('更换绑卡-非支持的快捷银行卡')
      phone="13600000018"
      url=ENV["rpc"]+"login"
      data={"name"=>"#{phone}","password"=>"123456"}
      reqbody= httppost(url,data)
      token=jsonlist reqbody,'.token'
      data={"token"=>"#{token}","bankname"=>"中信银行","cardno"=>"6217680702419743","province"=>"北京","city"=>"北京"}
      path='.error'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result=nil.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end


  def test_right3
    begin
      @html.newTestName('更换绑卡-用户与银行卡主人不一致')
      url=ENV["rpc"]+"login"
      data={"name"=>"13600000005","password"=>"123456"}
      reqbody= httppost(url,data)
      token=jsonlist reqbody,'.token'
      data={"token"=>"#{token}","cardno"=>"6227000011750218489","province"=>"北京","city"=>"北京"}
      path='.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result="".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end


end