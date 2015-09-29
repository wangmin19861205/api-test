

class Testinvest_user_coupons<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('invest_user_coupons')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/invest/user/coupons"
  end

  def teardown
    @conn.close
    @html.finishReport(@report, @test_environment)
  rescue => e
    puts $!
    puts e.backtrace
    @html.finishReport(@report, @test_environment)
  end

  #未完成
  def test_right
    @html.newTestName('投资使用加息券-正常')
    data={"token"=>@token,"loan_id"=>"700000790"}
    sql="select * from account_rewards where user_id = '2898945' and status = 'ACTIVE'  and begin_date <= current_date() and end_date >= current_date() and account_lender_pay_id is null and category in ('NO_LIMIT', 'RECOMMEND', 'NEWUSER_AND_RECOMMEND', 'RECOMMEND_AND_VIP')  "
    path='.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字[]'
    result=asskeylist(jsondata,sqldata,["id","user_id","amount","status","category"])
    @html.add_to_report(result,test)
  end

  #未完成
  def test_wrong
    @html.newTestName('投资使用加息券-参数为空')
    data={}
    sql="select * from account_rewards where user_id = '2898945' and status = 'ACTIVE'  and begin_date <= current_date() and end_date >= current_date() and account_lender_pay_id is null and category in ('NO_LIMIT', 'RECOMMEND', 'NEWUSER_AND_RECOMMEND', 'RECOMMEND_AND_VIP')  "
    path='.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字[]'
    result=asskeylist(jsondata,sqldata,["id","user_id","amount","status","category"])
    @html.add_to_report(result,test)
  end

  #未完成
  def test_wrong1
    @html.newTestName('投资使用加息券-参数值为空')
    data={"token"=>"","loan_id"=>""}
    sql="select * from account_rewards where user_id = '2898945' and status = 'ACTIVE'  and begin_date <= current_date() and end_date >= current_date() and account_lender_pay_id is null and category in ('NO_LIMIT', 'RECOMMEND', 'NEWUSER_AND_RECOMMEND', 'RECOMMEND_AND_VIP')  "
    path='.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字[]'
    result=asskeylist(jsondata,sqldata,["id","user_id","amount","status","category"])
    @html.add_to_report(result,test)
  end


end