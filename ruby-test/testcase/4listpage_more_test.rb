

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
    begin
      @html.newTestName('加载更多-短期项目')
      data={"type"=>"short","page"=>"1"}
      path='.loans[]'
      sql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'SHORT' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=asskey(jsondata,sqldata,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字loan_id'
      @html.add_to_report(result,test)
      end
    end

  def test_right1
    begin
      @html.newTestName('加载更多-中期项目')
      data={"type"=>"middle","page"=>"1"}
      path='.loans[]'
      sql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'MIDDLE' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=asskey(jsondata,sqldata,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test1 = '检查关键字loan_id'
      @html.add_to_report(result,test1)
    end
  end

  def test_right2
    begin
      @html.newTestName('加载更多-长期项目')
      data={"type"=>"long","page"=>"1"}
      path='.loans[]'
      sql="select * from loans where disabled = 0 and special_loan is null and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'LONG' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=asskey(jsondata,sqldata,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test1 = '检查关键字loan_id'
      @html.add_to_report(result,test1)
      end
    end

  def test_right3
    begin
      @html.newTestName('加载更多-新手项目')
      data={"type"=>"newuser","page"=>"1"}
      path='.loans[]'
      sql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and loan_type = 'NEWUSER_PROJECT' order by  case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 1"
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=asskey(jsondata,sqldata,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test1 = '检查关键字loan_id'
      @html.add_to_report(result,test1)
      end
    end

  def test_right4
    begin
      @html.newTestName('加载更多-VIP项目')
      data={"type"=>"vip","page"=>"1"}
      path='.loans[]'
      sql="select * from loans where disabled = 0 and special_loan is null and loan_type = 'VIP_PROJECT' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=asskey(jsondata,sqldata,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test1 = '检查关键字loan_id'
      @html.add_to_report(result,test1)
      end
    end

  #未完成
  def test_wrong
    begin
      @html.newTestName('加载更多-type错误')
      data={"type"=>"www","page"=>"1"}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result= "参数错误".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test1 = '检查关键字error=参数错误'
      @html.add_to_report(result,test1)
    end
  end

  #未完成
  def test_wrong1
    begin
      @html.newTestName('加载更多-参数为空')
      data={}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result= "参数错误".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test1 = '检查关键字error=参数错误'
      @html.add_to_report(result,test1)
      end
    end

  #未完成
  def test_wrong2
    begin
      @html.newTestName('加载更多-参数值为空')
      data={"type"=>"","page"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result= "参数错误".eql?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test1 = '检查关键字error=参数错误'
      @html.add_to_report(result,test1)
      end
    end

end