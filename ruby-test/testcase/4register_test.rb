


class Testregister<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('register')
    @phone='13522228410'
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    result=(Resultdiy.new(@conn.sqlquery("select * from users where secure_phone ='#{@phone}'")).result_to_list)
    if result[0]
      userid=result[0][:id]
      sql1="delete from accounts where user_id ='#{userid}'"
      sql2="delete from user_message_settings where user_id ='#{userid}'"
      sql3="delete from users where id='#{userid}'"
      @conn.update(sql1)
      @conn.update(sql2)
      @conn.update(sql3)
    end
    url=ENV["rpc"]+"register-send-phone-code"
    data={"phone"=>"#{@phone}","token"=>""}
    path=".token"
    reqbody=httppost(url,data)
    p reqbody
    @token=jsonlist reqbody,path
    sql="select content from sms_records where numbers = '#{@phone}' order by id desc limit 1"
    codetext=(Resultdiy.new(@conn.sqlquery(sql)).result_to_list[0])[:content]
    @code=/您的手机注册验证码为：(.*)，验证码10分钟内有效/.match(codetext).to_a[1]
    @url=ENV["rpc"]+"register"
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
      @html.newTestName('用户注册-正常')
      data={"phone"=>"#{@phone}","token"=>"#{@token}","code"=>"#{@code}","password"=>"123456","refer_phone"=>""}
      path='.user.secure_phone'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result="#{@phone}".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的secure_phone=#{@phone}"
      @html.add_to_report(result,test)
    end
  end

=begin
  #未完成
  def test_wrong
    begin
      @html.newTestName('用户注册-参数为空')
      data={}
      path='.data.user.secure_phone'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result="".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的secure_phone="
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong1
    begin
      @html.newTestName('用户注册-参数值为空')
      data={"phone"=>"","token"=>"#{@token}","code"=>"","password"=>"","refer_phone"=>""}
      path='.data.user.secure_phone'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result="".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的secure_phone="
      @html.add_to_report(result,test)
    end
  end

=end

end