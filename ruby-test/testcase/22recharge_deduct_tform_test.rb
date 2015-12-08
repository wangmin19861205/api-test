


class Testrecharge_deduct_tform<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('recharge-deduct-form')
    #MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    phone="13700000016"
    url=ENV["rpc"]+"login"
    data={"name"=>"#{phone}","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @url=ENV["rpc"]+"mobileapitest/recharge/deduct"
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
      data={"token"=>"#{@token}","amount"=>"5000"}
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
      @html.newTestName('代扣充值-单笔超过限额')
      data={"token"=>"#{@token}","amount"=>"100001"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result='代扣金额超过限额'.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end


  def test_right2
    begin
      @html.newTestName('代扣充值-单日超过限额')
      data={"token"=>"#{@token}","amount"=>"600000001"}
      path='.error'
      httppost(@url,data)
      sleep 5
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result='单日超过限额'.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end

  def test_right3
    begin
      @html.newTestName('代扣充值-用户银行卡非快捷')
      phone="13700000008"
      url=ENV["rpc"]+"login"
      data={"name"=>"#{phone}","password"=>"123456"}
      reqbody= httppost(url,data)
      token=jsonlist reqbody,'.token'
      data={"token"=>"#{token}","amount"=>"100"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result='用户银行卡非快捷'.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end


  def test_right4
    begin
      @html.newTestName('代扣充值-amount未非数字')
      data={"token"=>"#{@token}","amount"=>"sss"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result='金额参数错误'.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end


  def test_right5
    begin
      @html.newTestName('代扣充值-amount为空')
      data={"token"=>"#{@token}","amount"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result='金额参数错误'.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end


  def test_right6
    begin
      @html.newTestName('代扣充值-amount长度未限制')
      data={"token"=>"#{@token}","amount"=>"1234567890121456"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result='金额参数错误'.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end


  def test_right7
    begin
      @html.newTestName('代扣充值-amount金额小于5')
      data={"token"=>"#{@token}","amount"=>"1.5"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result='amount金额小于5'.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end
=end

end