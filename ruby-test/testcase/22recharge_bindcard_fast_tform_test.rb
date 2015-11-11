


class Testrecharge_bindcard_fast<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('recharge-bindcard-fast-tform')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    @phone="13600000010"
    @conn.delete("delete from account_cards where user_id =(select id from users where secure_phone = '#{@phone}') ")
    url=ENV["rpc"]+"login"
    data={"name"=>"#{@phone}","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @url=ENV["rpc"]+"mobileapitest/recharge-bindcard-fast"
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
      @html.newTestName('绑卡快捷充值-正常')
      data={"token"=>"#{@token}","cardno"=>"6222020200040016236","amount"=>"2000","phone"=>"#{@phone}","province"=>"北京","city"=>"北京"}
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
      @html.newTestName('绑卡快捷充值-非快捷')
      data={"token"=>"#{@token}","cardno"=>"6217680702419743","amount"=>"2000","phone"=>"#{@phone}","province"=>"北京","city"=>"北京"}
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
  def test_righ1
    begin
      @html.newTestName('绑卡快捷充值-银行卡余额不足代扣金额')
      data={"token"=>"#{@token}","cardno"=>"6222020200040016236","amount"=>"3000","phone"=>"#{@token}","province"=>"北京","city"=>"北京"}
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