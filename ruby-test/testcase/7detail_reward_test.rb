


class Testdetail_reward<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail_reward')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/detail/reward"
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
    @html.newTestName('项目可用抵现券-推荐项目')
    data={"token"=>@token,"page"=>"1","loan_type"=>"RECOMMEND_PROJECT"}
    sql="select * from account_rewards where user_id ='2898945' and status = 'ACTIVE' and account_lender_pay_id is null and category in ('RECOMMEND','NO_LIMIT','NEWUSER_AND_RECOMMEND','RECOMMEND_AND_VIP') "
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    #未完成
    test = '检查关键字:reward_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right1
    @html.newTestName('项目可用抵现券-新手项目')
    data={"token"=>@token,"page"=>"1","loan_type"=>"NEWUSER_PROJECT"}
    sql="select * from account_rewards where user_id ='2898945' and status = 'ACTIVE' and account_lender_pay_id is null and category in ('NEWUSER','NO_LIMIT','NEWUSER_AND_RECOMMEND') "
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字:reward_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right2
    @html.newTestName('项目可用抵现券-VIP项目')
    data={"token"=>@token,"page"=>"1","loan_type"=>"VIP_PROJECT"}
    sql="select * from account_rewards where user_id ='2898945' and status = 'ACTIVE' and account_lender_pay_id is null and category in ('VIP','NO_LIMIT','RECOMMEND_AND_VIP')"
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字:reward_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

end