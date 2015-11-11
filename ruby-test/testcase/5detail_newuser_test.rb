


class Testdetail_newuser<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail_newuser')
    phone="13500000069"
    url=ENV["rpc"]+"login"
    data={"name"=>phone,"password"=>"123456"}
    path='.token'
    reqbody=httppost(url,data)
    @token=jsonlist reqbody,path
    @url=ENV["rpc"]+"loan/detail/newuser"
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
      @html.newTestName('新手项目详情-项目状态：可投资')
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

  #未完成
  def test_right1
    begin
      @html.newTestName('新手项目详情-项目状态：已还款or还款中')
      data={"token"=>@token}
      sql="select id,title,annualized_rate,annualized_rate0,annualized_rate1,annualized_rate1,days_of_loan,min_invest_amount,uninvest_amount,loanproposal_id from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'NEWUSER_PROJECT' order by invest_open_time asc"
      repaysql="select id,title,annualized_rate,annualized_rate0,annualized_rate1,annualized_rate1,days_of_loan,min_invest_amount,uninvest_amount,loanproposal_id from loans where disabled = 0 and special_loan is null and special_user_id is null and status <> 'INVEST' and loan_type = 'NEWUSER_PROJECT' order by invest_open_time  desc limit 1"
      path='.newuser_loan'
      reqbody=httppost(@url,data)
      if Resultdiy.new(@conn.sqlquery(sql)).result_to_list
        idlist=[]
        (Resultdiy.new(@conn.sqlquery(sql)).result_to_list).each do |data|
          idlist.push(data[:id])
        end
        a=0
        str=""
        while a<idlist.length
          idlist.each do |i|
            if a+1 == idlist.length
              str=str+i.to_s
            else
              str=str+i.to_s+","
            end
            a=a+1
          end
        end
        str="("+str+")"    #idlist的字符串,为了传递进sql
        @conn.update("update loans set status='REPAY' where id in #{str}")
        sqldata=Resultdiy.new(@conn.sqlquery(repaysql)).result_to_list
        @conn.update("update loans set status='invest' where id in #{str}")
      else
        sqldata=Resultdiy.new(@conn.sqlquery(repaysql)).result_to_list
      end
      result=ass_with_sqlkey(reqbody,sqldata,path)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json与数据库data交集key的值对比'
      @html.add_to_report(result,test)
    end
  end

  def test_right2
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
  def test_right3
    begin
      @html.newTestName('新手项目详情-token错误')
      data={"token"=>"1234456"}
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