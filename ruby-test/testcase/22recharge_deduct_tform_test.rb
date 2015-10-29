


class Testrecharge_deduct_form<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('recharge-deduct-form')
    #MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    phone="13600000012"
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"#{phone}","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/mobileapitest/recharge/deduct"
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
      @html.newTestName('代扣充值-正常')
      data={"token"=>"#{@token}","amount"=>"10000"}
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
      @html.newTestName('快捷充值-单笔超过限额')
      data={"token"=>"#{@token}","amount"=>"50000","phone"=>"#{@phone}"}
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
      @html.newTestName('快捷充值-单日超过限额')
      data={"token"=>"#{@token}","amount"=>"4000","phone"=>"#{@phone}"}
      path='.error'
      httppost(@url,data)
      sleep 5
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
      @html.newTestName('快捷充值-用户银行卡非快捷')
      data={"token"=>"#{@token}","amount"=>"50000","phone"=>"#{@phone}"}
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

  def test_right4
    begin
      @html.newTestName('快捷充值-amount未非数字')
      data={"token"=>"#{@token}","amount"=>"sss","phone"=>"#{@phone}"}
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

  def test_right5
    begin
      @html.newTestName('快捷充值-amount为空')
      data={"token"=>"#{@token}","amount"=>"","phone"=>"#{@phone}"}
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

  def test_right6
    begin
      @html.newTestName('快捷充值-amount长度未限制')
      data={"token"=>"#{@token}","amount"=>"1234567890123456","phone"=>"#{@phone}"}
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

  def test_right7
    begin
      @html.newTestName('快捷充值-amount金额小于5')
      data={"token"=>"#{@token}","amount"=>"4.5","phone"=>"#{@phone}"}
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

  def test_right8
    begin
      @html.newTestName('快捷充值-phone与银行卡绑定手机号不一致')
      data={"token"=>"#{@token}","amount"=>"100","phone"=>"13512345678"}
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


end