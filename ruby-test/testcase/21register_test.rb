


class Testregister<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('register')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    result=(Resultdiy.new(@conn.sqlquery("select * from users where secure_phone ='13500000098'")).result_to_list)
    if result[0]
      userid=result[0][:id]
      sql1="delete from accounts where user_id ='#{userid}'"
      sql2="delete from user_message_settings where user_id ='#{userid}'"
      sql3="delete from users where id='#{userid}'"
      @conn.update(sql1)
      @conn.update(sql2)
      @conn.update(sql3)
    end
    url="http://rpc.wangmin.test.zrcaifu.com/send_register_code"
    data={"phone"=>"13500000098"}
    httppost(url,data)
    sql="select content from sms_records where numbers = '13500000098' order by id desc limit 1"
    codetext=(Resultdiy.new(@conn.sqlquery(sql)).result_to_list[0])[:content]
    @auth_code=/您的验证码是: (.*)/.match(codetext).to_a[1]
    @url="http://rpc.wangmin.test.zrcaifu.com/register"
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
    @html.newTestName('用户注册-正常')
    data={"phone"=>"13500000098","auth_code"=>"#{@auth_code}","password"=>"123456","refer_phone"=>""}
    path='.data.user.secure_phone'
    begin
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result="13500000098".eql?jsondata
    rescue Exception
    end
    test="检查json中的secure_phone=13500000098"
    @html.add_to_report(result,test)
  end


end