

class Testinvest_user_rewards<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('invest_user_rewards')
    projectdatas=Resultdiy.new(@conn.sqlquery("select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc")).result_to_list
    loansid=[]
    projectdatas.each do |data|
      loansid.push(data[:id])
    end
    @id=loansid.sample
    phone="13500000069"
    url=ENV["rpc"]+"login"
    data={"name"=>phone,"password"=>"123456"}
    path='.token'
    reqbody=httppost(url,data)
    @token=jsonlist reqbody,path
    @user_id=jsonlist reqbody,'.user.id'
    @url=ENV["rpc"]+"invest/user/rewards"
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
      @html.newTestName('投资选择抵现券-正常')
      data={"token"=>@token,"loan_id"=>@id,"page"=>"1"}
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
      @html.newTestName('投资选择抵现券-参数值为空')
      data={"token"=>"","loan_id"=>"","page"=>"1"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result="参数错误".eql?(jsondata)
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
      @html.newTestName('投资选择抵现券-参数为空')
      data={}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result="参数错误".eql?(jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字'
      @html.add_to_report(result,test)
    end
  end




end