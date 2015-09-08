

class Testsend_register_code<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('send_register_code')
    @url="http://rpc.wangmin.test.zrcaifu.com/send_register_code"
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
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
    @html.newTestName('注册验证码-正常')
    begin
      data={"phone"=>"13500000098"}
      path='.data.data.success'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result=(true.eql?jsondata)
    rescue Exception
    end
    test="检查json的success为TRUE"
    @html.add_to_report(result,test)
  end


end