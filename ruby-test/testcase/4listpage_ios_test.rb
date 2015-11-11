

class Testlistpage_ios<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('listpage_ios')
    @url=ENV["rpc"]+"listpage"
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
      @html.newTestName('全部项目ios-正常')
      newsql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and loan_type = 'NEWUSER_PROJECT' order by  case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset  0"
      vipsql="select * from loans where disabled = 0 and special_loan is null and loan_type = 'VIP_PROJECT' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
      shortsql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'SHORT' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
      middlesql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'MIDDLE' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
      longsql="select * from loans where disabled = 0 and special_loan is null and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'LONG' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"
      newpath='.newuser_loans.loans[]'
      vippath='.vip_loans.loans[]'
      shortpath='.short_loans.loans[]'
      middlepath='.middle_loans.loans[]'
      longpath='.long_loans.loans[]'
      reqbody=httpget(@url)
      newjsondata=jsonlist reqbody,newpath
      vipjsondata=jsonlist reqbody,vippath
      shortjsondata=jsonlist reqbody,shortpath
      middlejsondata=jsonlist reqbody,middlepath
      longjsondata=jsonlist reqbody,longpath
      newsqldata=Resultdiy.new(@conn.sqlquery(newsql)).result_to_list
      vipsqldata=Resultdiy.new(@conn.sqlquery(vipsql)).result_to_list
      shortsqldata=Resultdiy.new(@conn.sqlquery(shortsql)).result_to_list
      middlesqldata=Resultdiy.new(@conn.sqlquery(middlesql)).result_to_list
      longsqldata=Resultdiy.new(@conn.sqlquery(longsql)).result_to_list
      result=asskey(newjsondata,newsqldata,["id",:id])
      result1=asskey(vipjsondata,vipsqldata,["id",:id])
      result2=asskey(shortjsondata,shortsqldata,["id",:id])
      result3=asskey(middlejsondata,middlesqldata,["id",:id])
      result4=asskey(longjsondata,longsqldata,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字:新手项目id'
      @html.add_to_report(result,test)
      test = '检查关键字:VIP项目id'
      @html.add_to_report(result1,test)
      test = '检查关键字:短期项目id'
      @html.add_to_report(result2,test)
      test = '检查关键字:中期项目id'
      @html.add_to_report(result3,test)
      test = '检查关键字:长期项目id'
      @html.add_to_report(result4,test)
      end
    end


end