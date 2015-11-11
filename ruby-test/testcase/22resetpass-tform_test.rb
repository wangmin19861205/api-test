


class Testresetpass_tform<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('resetpass-tform')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    phone="13700000001"
    url=ENV["rpc"]+"login"
    data={"name"=>"#{phone}","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @url=ENV["rpc"]+"mobileapitest/resetpass"
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
      @html.newTestName('修改密码-正常')
      data={"token"=>"#{@token}"}
      path='.error'
      path1='.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      jsondata1=jsonlist reqbody,path1
      result=nil.eql?jsondata
      result1=nil.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值=nil"
      @html.add_to_report(result,test)
      test1="检查json中的msg值=nil"
      @html.add_to_report(result1,test1)
    end
  end


end