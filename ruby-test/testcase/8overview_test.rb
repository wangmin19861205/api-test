



class Testoverview<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('overview')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000069","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/overview"
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
      @html.newTestName('用户概览-正常')
      data={"token"=>@token}
      sql="select available_money,available_reward,frozen_money_withdraw,receivable_principal,receivable_interest,accumulate_interest,balance_available,balance_total from `accounts` where user_id ='#{@user_id}'"
      path='.account'
      reqbody=httppost(@url,data)
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=ass_with_sqlkey reqbody,sqldata,path
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json与数据库data交集key的值对比'
      @html.add_to_report(result,test)
    end
  end


  def test_wrong
    begin
      @html.newTestName('用户概览-错误token')
      data={"token"=>"rui-session:5d28737b-ce8c1-43d0-b20c-799b54ffe12f"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result=  "token 失效".eql?(jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的error：token 失效'
      @html.add_to_report(result,test)
    end
  end



  #外完成
  def test_wrong1
    begin
      @html.newTestName('用户概览-参数为空')
      data={}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result="token 失效".eql?(jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的error：token 失效'
      @html.add_to_report(result,test)
    end
  end


  #外完成
  def test_wrong2
    begin
      @html.newTestName('用户概览-参数值为空')
      data={"token"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result="token 失效".eql?(jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json中的error：token 失效'
      @html.add_to_report(result,test)
    end
  end


end