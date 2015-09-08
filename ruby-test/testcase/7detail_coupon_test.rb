


class Testdetail_coupon<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail_coupon')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/detail/coupon"
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
    @html.newTestName('项目可用加息券-限推荐项目')
    data={"token"=>@token,"page"=>"1","loan_type"=>"RECOMMEND_PROJECT"}
    sql="select * from account_interest_coupons where user_id='2898945' and status = 'ACTIVE' and loan_type = 'RECOMMEND_PROJECT'   "
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字:reward_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right1
    @html.newTestName('项目可用加息券-限新手项目')
    data={"token"=>@token,"page"=>"1","loan_type"=>"NEWUSER_PROJECT"}
    sql="select * from account_interest_coupons where user_id='2898945' and status = 'ACTIVE' and loan_type = 'NEWUSER_PROJECT'   "
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    #未完成
    test = '检查关键字:reward_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right2
    @html.newTestName('项目可用加息券-限VIP项目')
    data={"token"=>@token,"page"=>"1","loan_type"=>"VIP_PROJECT"}
    sql="select * from account_interest_coupons where user_id='2898945' and status = 'ACTIVE' and loan_type = 'VIP_PROJECT'   "
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字:reward_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

end