

class Testlogin<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('login')
    @url=ENV["rpc"]+"login"
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
    @html.newTestName('用户登录-正常')
    user_phone="13500000069"
    data={"name"=>"#{user_phone}","password"=>"123456"}
    sql="select * from users where secure_phone = '#{user_phone}'"
    path='.user'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字user_id'
    result=asskey jsondata,sqldata,["id",:id]
    @html.add_to_report(result,test)
    test1 = '检查json中的error为空'
    @html.add_to_report((nil.equal?(jsonlist reqbody,'.error')),test1)
    test2 = '检查json中的token不为空'
    @html.add_to_report((jsonlist reqbody,'.token') != nil,test2)
  end

  def test_wrong
    @html.newTestName('用户登录-密码错误')
    user_phone="13500000069"
    data={"name"=>"#{user_phone}","password"=>"1231456"}
    path='.error.msg'
    begin
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result = "账号或密码错误，请重新输入".eql?jsondata
    rescue Exception=>e
        result=[false,e.message]
    ensure
      test = '检查json中的error为密码错误'
      @html.add_to_report(result,test)
    end
  end

  def test_wrong1
    begin
      @html.newTestName('用户登录-用户名错误')
      user_phone="1350000006911"
      data={"name"=>"#{user_phone}","password"=>"123456"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      p reqbody
      jsondata=jsonlist reqbody,path
      result= "请输入正确的手机号码".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的error为用户名错误'
      @html.add_to_report(result,test)
    end
    end

  def test_wrong2
    begin
      @html.newTestName('用户登录-用户名为空')
      data={"name"=>"","password"=>""}
      path='.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result= "用户名未填写".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的msg为:用户名未填写'
      @html.add_to_report(result,test)
    end
    end

#未完成
  def test_wrong3
    begin
      @html.newTestName('用户登录-密码为空')
      data={"name"=>"13500000069","password"=>""}
      path='.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result = "密码未填写".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的msg为:密码未填写'
      @html.add_to_report(result,test)
    end
    end

#未完成
  def test_wrong4
    begin
      @html.newTestName('用户登录-参数为空')
      data={}
      path='.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result=  "用户名未填写".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的msg为:用户名未填写'
      @html.add_to_report(result,test)
    end
    end

#未完成
  def test_wrong5
    begin
      @html.newTestName('用户登录-参数值为空')
      data={"name"=>"","password"=>""}
      path='.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result= "用户名未填写".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的msg为:用户名未填写'
      @html.add_to_report(result,test)
    end
    end

end