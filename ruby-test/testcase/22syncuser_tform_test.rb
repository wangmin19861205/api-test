


class Syncuser_tform<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('syncuser-tform')
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
    @conn.update("update users set idcard_number = '43042119861205001' where idcard_number ='430421198612050018'")
    @url="http://rpc.wangmin.test.zrcaifu.com/mobileapitest/syncuser"
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
      @html.newTestName('开户-注册后，正常开户')
      phone="13600000018"
      #删除已存在的用户
      result=(Resultdiy.new(@conn.sqlquery("select * from users where secure_phone ='#{phone}'")).result_to_list)
      if result[0]
        userid=result[0][:id]
        sql1="delete from accounts where user_id ='#{userid}'"
        sql2="delete from user_message_settings where user_id ='#{userid}'"
        sql3="delete from users where id='#{userid}'"
        @conn.update(sql1)
        @conn.update(sql2)
        @conn.update(sql3)
      end
      #请求注册验证码及token
      url="http://rpc.wangmin.test.zrcaifu.com/register-send-phone-code"
      data={"phone"=>"#{phone}","token"=>""}
      path=".token"
      reqbody=httppost(url,data)
      token=jsonlist reqbody,path
      #获取注册的验证码
      sql="select content from sms_records where numbers = '#{phone}' order by id desc limit 1"
      codetext=(Resultdiy.new(@conn.sqlquery(sql)).result_to_list[0])[:content]
      code=/您的手机注册验证码为：(.*)，验证码10分钟内有效/.match(codetext).to_a[1]
      #====================================================
      data={"phone"=>"#{phone}","token"=>"#{token}","code"=>"#{code}","password"=>"123456","refer_phone"=>""}
      url1="http://rpc.wangmin.test.zrcaifu.com/register"
      httppost(url1,data)
      #获取登录后的token===============================================
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"#{phone}","password"=>"123456"}
      reqbody= httppost(url,data)
      token=jsonlist reqbody,'.token'
      #====================================================
      data={"token"=>"#{token}","idcard_name"=>"王敏","idcard_number"=>"430421198612050018"}
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



  def test_wrong1
    begin
      @html.newTestName('开户-用户不存在')
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"13500000053","password"=>"123456"}
      reqbody= httppost(url,data)
      token=jsonlist reqbody,'.token'
      data={"token"=>"#{token}","idcard_name"=>"王敏","idcard_number"=>"430421198612050018"}
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



  def test_wrong2
    begin
      @html.newTestName('开户-用户已开户')
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"13500000069","password"=>"123456"}
      reqbody = httppost(url,data)
      token=jsonlist reqbody,'.token'
      data1={"token"=>"#{token}","idcard_name"=>"王轩","idcard_number"=>"120222199003074652"}
      path='.error.msg'
      reqbody1=httppost(@url,data1)
      p reqbody1
      jsondata=jsonlist reqbody1,path
      result='该用户已经开通托管账号'.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end


  def test_wrong3
    begin
      @html.newTestName('开户-token失效')
      data1={"token"=>"rui-session:50b801d0-eb27-4281-9a2e-e6c08a0e0a53","idcard_name"=>"王敏","idcard_number"=>"430421198612050018"}
      path='.error.msg'
      reqbody1=httppost(@url,data1)
      p reqbody1
      jsondata=jsonlist reqbody1,path
      result='token 失效'.eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json中的error值"
      @html.add_to_report(result,test)
    end
  end



  def test_wrong4
    begin
      @html.newTestName('开户-身份证及名字错误')
      phone="13600000018"
      result=(Resultdiy.new(@conn.sqlquery("select * from users where secure_phone ='#{phone}'")).result_to_list)
      if result[0]
        userid=result[0][:id]
        sql1="delete from accounts where user_id ='#{userid}'"
        sql2="delete from user_message_settings where user_id ='#{userid}'"
        sql3="delete from users where id='#{userid}'"
        @conn.update(sql1)
        @conn.update(sql2)
        @conn.update(sql3)
      end
      url="http://rpc.wangmin.test.zrcaifu.com/register-send-phone-code"
      data={"phone"=>"#{phone}","token"=>""}
      path=".token"
      reqbody=httppost(url,data)
      token=jsonlist reqbody,path
      sql="select content from sms_records where numbers = '#{phone}' order by id desc limit 1"
      codetext=(Resultdiy.new(@conn.sqlquery(sql)).result_to_list[0])[:content]
      code=/您的手机注册验证码为：(.*)，验证码10分钟内有效/.match(codetext).to_a[1]
      data={"phone"=>"#{phone}","token"=>"#{token}","code"=>"#{code}","password"=>"123456","refer_phone"=>""}
      url1="http://rpc.wangmin.test.zrcaifu.com/register"
      p data
      httppost(url1,data)
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"#{phone}","password"=>"123456"}
      reqbody= httppost(url,data)
      token=jsonlist reqbody,'.token'
      data={"token"=>"#{token}","idcard_name"=>"王天","idcard_number"=>"430421198612050018"}
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