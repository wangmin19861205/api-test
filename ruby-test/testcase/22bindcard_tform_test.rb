


class Testbindcard_tform<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('bindcard-tform')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    phone="13500000069"
    @conn.update("update users set idcard_number = '43042119861205001' where idcard_number ='430421198612050018'")
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


end