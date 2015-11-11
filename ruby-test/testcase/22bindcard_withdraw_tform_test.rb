


class Testbindcard_withdraw_tform<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('bindcard-withdraw-tform')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    @url=ENV["rpc"]+"mobileapitest/bindcardwithdraw"
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
      @html.newTestName('绑卡提现-正常')
      phone="13700000002"
      @conn.update("delete from account_cards where user_id =(select id from users where secure_phone = '#{phone}') ")
      url=ENV["rpc"]+"login"
      data={"name"=>"#{phone}","password"=>"123456"}
      path='.token'
      reqbody= httppost(url,data)
      token=jsonlist reqbody,path
      #======================================
      data={"token"=>"#{token}","amount"=>"100","cardno"=>"6222020200040016236","province"=>"北京","city"=>"北京"}
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