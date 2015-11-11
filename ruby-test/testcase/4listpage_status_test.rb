


class Testlistpage_status<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('listpage_status')
    @url=ENV["rpc"]+"listpage/status"
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
      @html.newTestName('可投项目类型-正常')
      newusersql="select count(*)  as newuser_avail from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'NEWUSER_PROJECT'"
      shortsql="select count(*) as short_avail from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'SHORT'"
      middlesql="select count(*) as middle_avail from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'MIDDLE'"
      longsql="select count(*) as long_avail from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'LONG'"
      vipsql="select count(*) as vip_avail from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'VIP_PROJECT'"
      path=''
      reqbody=httpget(@url)
      jsondata=jsonlist reqbody,path
      newsqldata=Resultdiy.new(@conn.sqlquery(newusersql)).result_to_list
      shortsqldata=Resultdiy.new(@conn.sqlquery(shortsql)).result_to_list
      middlesqldata=Resultdiy.new(@conn.sqlquery(middlesql)).result_to_list
      longsqldata=Resultdiy.new(@conn.sqlquery(longsql)).result_to_list
      vipsqldata=Resultdiy.new(@conn.sqlquery(vipsql)).result_to_list
      sqldata=newsqldata[0].merge(shortsqldata[0]).merge(middlesqldata[0]).merge(longsqldata[0]).merge(vipsqldata[0])
      sqldata1=[]
      sqldata.each_value do |value|
        sqldata1.push(value > 0 ? true : false)
      end
      result= jsondata.values == sqldata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查项目可投状态--全部'
      @html.add_to_report(result,test)
      end
    end


end