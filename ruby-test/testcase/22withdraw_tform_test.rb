


class Testwithdraw_tform<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('withdraw-tform')
    #MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    phone="13600000017"
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"#{phone}","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/mobileapitest/withdraw"
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
      @html.newTestName('提现-正常')
      data={"token"=>"#{@token}","amount"=>"199"}
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
      @html.newTestName('提现-余额为0')
      data={"token"=>"#{@token}","amount"=>"1000"}
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
      @html.newTestName('提现-提现金额大于余额')
      data={"token"=>"#{@token}","amount"=>"2000"}
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
      @html.newTestName('提现-提现金额大于限额')
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

  def test_right4
    begin
      @html.newTestName('提现-amount为非数字')
      data={"token"=>"#{@token}","amount"=>"ssss"}
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
      @html.newTestName('提现-amount为空')
      data={"token"=>"#{@token}","amount"=>""}
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
      @html.newTestName('提现-amount<0.01')
      data={"token"=>"#{@token}","amount"=>"0.004"}
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
      @html.newTestName('提现-amount最长16位')
      data={"token"=>"#{@token}","amount"=>"1234567890123456"}
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
=end



end