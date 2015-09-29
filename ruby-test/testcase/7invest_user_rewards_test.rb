

class Testinvest_user_rewards<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('invest_user_rewards')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000069","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
    @url="http://rpc.wangmin.test.zrcaifu.com/invest/user/rewards"
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
      @html.newTestName('投资使用抵现券-正常')
      data={"token"=>@token,"loan_id"=>"700000835","page"=>"1"}
      sql="select * from account_rewards where user_id = '#{@user_id}' and status = 'ACTIVE'  and begin_date <= current_date() and end_date >= current_date() and account_lender_pay_id is null and category in ('NO_LIMIT','RECOMMEND', 'NEWUSER_AND_RECOMMEND' ,'RECOMMEND_AND_VIP') order by end_date desc limit 10 offset  0"
      path='.data'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=asskeylist(jsondata,sqldata,["id","user_id","amount","status","category"])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字[]'
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong
    begin
      @html.newTestName('投资使用抵现券-参数值为空')
      data={"token"=>"","loan_id"=>"","page"=>"1"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result="token 失效".eql?(jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字[]'
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong1
    begin
      @html.newTestName('投资使用抵现券-参数为空')
      data={}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result="token 失效".eql?(jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字'
      @html.add_to_report(result,test)
    end
  end




end