require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testaccount_investlist<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_investlist')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/investlist"
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
    @html.newTestName('投资记录-未还款')
    data1={"token"=>@token,"repay_type"=>"0","page"=>"1"}
    sql1="select invests.* ,  sum(case invest_receives.done when 1 then  invest_receives.amount_interest else 0 end) as invest_received_amount ,
   sum(case invest_receives.done when 0 then invest_receives.amount_interest else 0 end) as invest_unreceived_amount
  from invests, invest_receives where invests.user_id = '2898945' and invests.id = invest_receives.invest_id and case loan_repay_status when 'ALL' then 1 else 0 end = 0
  group by invests.id order by create_time desc limit 20 offset 0  "
    path='.data.data[]'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字invest_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end


  #未完成
  def test_right1
    @html.newTestName('投资记录-已还款')
    data1={"token"=>@token,"repay_type"=>"1","page"=>"1"}
    sql1="select invests.* , invests.interest as amount_interest, sum(case invest_receives.done when 1 then  invest_receives.amount_interest else 0 end) as invest_received_amount , invests.interest - sum(case invest_receives.done when 1 then  invest_receives.amount_interest else 0 end) as invest_unreceived_amount from invests, invest_receives where invests.user_id = '2898945' and invests.id = invest_receives.invest_id and case loan_repay_status when 'ALL' then 1 else 0 end = 1 group by invests.id order by invests.create_time desc limit 20 offset 0"
    path='.data.data[]'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字invest_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end


end