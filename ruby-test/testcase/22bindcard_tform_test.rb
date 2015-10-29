


class Testbindcard_tform<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('bindcard-tform')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    phone="13600000006"
    @conn.delete("delete from account_cards where user_id =(select id from users where secure_phone = '#{phone}') ")
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"#{phone}","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/mobileapitest/bindcard"
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
      @html.newTestName('绑卡-正常')
      data={"token"=>"#{@token}","cardno"=>"6222020200040016236","province"=>"北京","city"=>"北京"}
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


=begin
  def test_right1
    begin
      @html.newTestName('绑卡-非支持的快捷银行卡')
      data={"token"=>"#{@token}","cardno"=>"6217680702419743","province"=>"北京","city"=>"北京"}
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



  def test_right2
    begin
      @html.newTestName('绑卡-用户已绑卡')
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"13500000069","password"=>"123456"}
      reqbody= httppost(url,data)
      @token=jsonlist reqbody,'.token'
      data={"token"=>"#{@token}","cardno"=>"6222020200040016236","province"=>"北京","city"=>"北京"}
      path='.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result="该客户已绑定银行卡号为6222020200040016236,为保证资金安全，目前不支持更换其他银行卡".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end



  def test_right3
    begin
      @html.newTestName('绑卡-用户与银行卡主人不一致')
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"13600000018","password"=>"123456"}
      reqbody= httppost(url,data)
      @token=jsonlist reqbody,'.token'
      data={"token"=>"#{@token}","cardno"=>"6217680702416103","province"=>"北京","city"=>"北京"}
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
=end
=begin
  def test_right4
    begin
      @html.newTestName('绑卡-银行卡已被使用')
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"13500000069","password"=>"123456"}
      reqbody= httppost(url,data)
      @token=jsonlist reqbody,'.token'
      data={"token"=>"#{@token}","cardno"=>"6227000011750218489","province"=>"北京","city"=>"北京"}
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


  def test_right5
    begin
      @html.newTestName('绑卡-银行卡余额少于5元')
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"13500000069","password"=>"123456"}
      reqbody= httppost(url,data)
      @token=jsonlist reqbody,'.token'
      data={"token"=>"#{@token}","cardno"=>"6227000011750218489","province"=>"北京","city"=>"北京"}
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
=end

  def test_right6
    begin
      @html.newTestName('绑卡-用户未开通民生')
      phone="13600000016"
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"#{phone}","password"=>"123456"}
      reqbody= httppost(url,data)
      token=jsonlist reqbody,'.token'
      data={"token"=>"#{token}","cardno"=>"6222020200040016236","province"=>"北京","city"=>"北京"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result='该用户未开通托管账号'.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值='该用户未开通托管账号'"
      @html.add_to_report(result,test)
    end
  end




end