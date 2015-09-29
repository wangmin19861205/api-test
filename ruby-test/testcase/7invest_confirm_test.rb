

class Testinvest_confirm<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('invest_confirm')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.token'
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
    @html.newTestName('投资确认-正常')
    data={"token"=>@token,"loan_id"=>"700000790"}
    rewards_sql="select count(*) as rewards  from account_rewards
                              where user_id = '2898945' and status = 'ACTIVE'
                              and begin_date <= current_date() and end_date >= current_date()
                              and account_lender_pay_id is null and category in ('NO_LIMIT', 'RECOMMEND', 'NEWUSER_AND_RECOMMEND', 'RECOMMEND_AND_VIP') "
    coupons_sql="select count(*) as coupons from account_interest_coupons
                    where user_id = '2898945' and status ='ACTIVE'
                    and begin_date <= current_date() and end_date >= current_date() and (loan_type = 'RECOMMEND_PROJECT' or loan_type is null) and category is null  "
    path=''
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(rewards_sql)).result_to_list
    sqldata1=Resultdiy.new(@conn.sqlquery(coupons_sql)).result_to_list
    test = '检查关键字reward'
    result=asskey(jsondata,sqldata,["rewards_count",:rewards])
    @html.add_to_report(result,test)
    test = '检查关键字coupons'
    result=asskey(jsondata,sqldata1,["coupons_count",:coupons])
    @html.add_to_report(result,test)
  end



end