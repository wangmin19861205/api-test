


class Testdetail_newuser<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail_newuser')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000069","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/loan/detail/newuser"
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
      @html.newTestName('新手项目详情-token正常')
      data={"token"=>@token}
      sql="select id,title,annualized_rate,annualized_rate0,annualized_rate1,annualized_rate1,days_of_loan,min_invest_amount,uninvest_amount,loanproposal_id from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'NEWUSER_PROJECT' order by invest_open_time asc limit 1"
      path='.newuser_loan'
      reqbody=httppost(@url,data)
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=ass_with_sqlkey(reqbody,sqldata,path)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json与数据库data交集key的值对比'
      @html.add_to_report(result,test)
      end
    end

  def test_right1
    begin
      @html.newTestName('新手项目详情-token为空')
      data={"token"=>""}
      sql="select id,title,annualized_rate,annualized_rate0,annualized_rate1,annualized_rate1,days_of_loan,min_invest_amount,uninvest_amount,loanproposal_id from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'NEWUSER_PROJECT' order by invest_open_time asc limit 1"
      path='.newuser_loan'
      reqbody=httppost(@url,data)
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=ass_with_sqlkey(reqbody,sqldata,path)
    rescue Exception=>e
      result=[false,e.message]
    ensure
    test = '检查json与数据库data交集key的值对比'
    @html.add_to_report(result,test)
  end
 end

  #未完成
  def test_right2
    begin
      @html.newTestName('新手项目详情-token错误')
      data={"token"=>""}
      sql="select id,title,annualized_rate,annualized_rate0,annualized_rate1,annualized_rate1,days_of_loan,min_invest_amount,uninvest_amount,loanproposal_id from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'NEWUSER_PROJECT' order by invest_open_time asc limit 1"
      path='.newuser_loan'
      reqbody=httppost(@url,data)
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=ass_with_sqlkey(reqbody,sqldata,path)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json与数据库data交集key的值对比'
      @html.add_to_report(result,test)
      end
    end

#未完成 预期:
  def test_wrong
    begin
      @html.newTestName('新手项目详情-参数为空')
      data={}
      sql="select id,title,annualized_rate,annualized_rate0,annualized_rate1,annualized_rate1,days_of_loan,min_invest_amount,uninvest_amount,loanproposal_id from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'NEWUSER_PROJECT' order by invest_open_time asc limit 1"
      path='.newuser_loan'
      reqbody=httppost(@url,data)
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=ass_with_sqlkey(reqbody,sqldata,path)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json与数据库data交集key的值对比'
      @html.add_to_report(result,test)
      end
  end


  #未完成，需添加新手项目为空，只有还款状态的case
end