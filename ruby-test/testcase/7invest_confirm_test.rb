

class Testinvest_confirm<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('invest_confirm')
    projectdatas=Resultdiy.new(@conn.sqlquery("select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc")).result_to_list
    loansid=[]
    projectdatas.each do |data|
      loansid.push(data[:id])
    end
    @id=loansid.sample
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000069","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
    @url="http://rpc.wangmin.test.zrcaifu.com/invest/confirm"
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
      @html.newTestName('投资确认-正常')
      data={"token"=>@token,"loan_id"=>@id}
      rewards_sql="select count(*) as rewards  from account_rewards
                                where user_id = '#{@user_id}' and status = 'ACTIVE'
                                and begin_date <= current_date() and end_date >= current_date()
                                and account_lender_pay_id is null and category in ('NO_LIMIT', 'RECOMMEND', 'NEWUSER_AND_RECOMMEND', 'RECOMMEND_AND_VIP') "
      coupons_sql="select count(*) as coupons from account_interest_coupons
                      where user_id = '#{@user_id}' and status ='ACTIVE'
                      and begin_date <= current_date() and end_date >= current_date() and (loan_type = 'RECOMMEND_PROJECT' or loan_type is null) and category is null  "
      path=''
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      sqldata=Resultdiy.new(@conn.sqlquery(rewards_sql)).result_to_list
      sqldata1=Resultdiy.new(@conn.sqlquery(coupons_sql)).result_to_list
      result=asskey(jsondata,sqldata,["rewards_count",:rewards])
      result=asskey(jsondata,sqldata1,["coupons_count",:coupons])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字reward'
      @html.add_to_report(result,test)
      test = '检查关键字coupons'
      @html.add_to_report(result,test)
    end
  end


  #未完成,没有处理，直接返回的0，0
  def test_wrong
    begin
      @html.newTestName('投资确认-参数值为空')
      data={"token"=>'',"loan_id"=>""}
      path='.rewards_count'
      path1='.coupons_count'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      jsondata1=jsonlist reqbody,path1
      result= 0.eql?jsondata
      result1= 0.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字reward'
      @html.add_to_report(result,test)
      test = '检查关键字coupons'
      @html.add_to_report(result1,test)
    end
  end

  #未完成,没有处理，直接返回的0，0
  def test_wrong1
    begin
      @html.newTestName('投资确认-参数为空')
      data={}
      path='.rewards_count'
      path1='.coupons_count'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      jsondata1=jsonlist reqbody,path1
      result= 0.eql?jsondata
      result1= 0.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字reward'
      @html.add_to_report(result,test)
      test = '检查关键字coupons'
      @html.add_to_report(result1,test)
    end
  end

end