

class Testlistpage_more<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('listpage_more')
    @url="http://rpc.wangmin.test.zrcaifu.com/listpage/more"
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
    @html.newTestName('加载更多-短期项目')
    data={"type"=>"short","page"=>"1"}
    path='.data.loans.loans[]'
    sql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'SHORT' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查长度'
    @html.add_to_report(((asslength jsondata,sqldata)),test)
    test = '检查关键字loan_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right1
    @html.newTestName('加载更多-中期项目')
    data={"type"=>"middle","page"=>"1"}
    path='.data.loans.loans[]'
    sql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'MIDDLE' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查长度'
    @html.add_to_report(((asslength jsondata,sqldata)),test)
    test1 = '检查关键字loan_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test1)
  end

  def test_right2
    @html.newTestName('加载更多-长期项目')
    data={"type"=>"long","page"=>"1"}
    path='.data.loans.loans[]'
    sql="select * from loans where disabled = 0 and special_loan is null and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'LONG' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查长度'
    @html.add_to_report((( asslength jsondata,sqldata)),test)
    test1 = '检查关键字loan_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test1)
  end

  def test_right3
    @html.newTestName('加载更多-新手项目')
    data={"type"=>"newuser","page"=>"1"}
    path='.data.loans.loans[]'
    sql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and loan_type = 'NEWUSER_PROJECT' order by  case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 1"
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查长度'
    @html.add_to_report(((asslength jsondata,sqldata)),test)
    test1 = '检查关键字loan_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test1)
  end

  def test_right4
    @html.newTestName('加载更多-VIP项目')
    data={"type"=>"vip","page"=>"1"}
    path='.data.loans.loans[]'
    sql="select * from loans where disabled = 0 and special_loan is null and loan_type = 'VIP_PROJECT' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查长度'
    @html.add_to_report(((asslength jsondata,sqldata)),test)
    test1 = '检查关键字loan_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test1)
  end

end