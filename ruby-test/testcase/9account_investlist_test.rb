

class Testaccount_investlist<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_investlist')
    phone="13500000069"
    url=ENV["rpc"]+"login"
    data={"name"=>phone,"password"=>"123456"}
    path='.token'
    reqbody=httppost(url,data)
    @token=jsonlist reqbody,path
    @user_id=jsonlist reqbody,'.user.id'
    @url=ENV["rpc"]+"account/investlist"
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
      @html.newTestName('投资记录-未还款')
      data1={"token"=>@token,"repay_type"=>"0","page"=>"1"}
      sql1="select * from
       (select invests.* ,
               invests.interest as amount_interest,
               sum(case invest_receives.done when 1 then invest_receives.amount_interest else 0 end) as invest_received_amount ,
               invests.interest - sum(case invest_receives.done when 1 then invest_receives.amount_interest else 0 end) as invest_unreceived_amount
        from invests, invest_receives, loans
        where invests.user_id = '#{@user_id}'
          and invests.loan_id = loans.id and invests.id = invest_receives.invest_id
          and case invests.loan_repay_status when 'ALL' then 1 else 0 end = 0
        group by invests.id order by

               case when 0 = 1 then invests.last_repay_date end desc,
               case when 0 = 0 then invests.create_time end desc
     )
     as t limit 20 offset 0  "
      path='.data'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
      result=asskeylist(jsondata1,sqldata1,["id","annualized_rate","amount","invest_received_amount","invest_unreceived_amount"])
      result1=asskey(jsondata1,sqldata1,["amount_interest",:interest])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字invest_id'
      @html.add_to_report(result,test)
      test = '检查关键字amount_interest'
      @html.add_to_report(result1,test)
    end
  end



  #未完成
  def test_right1
    begin
      @html.newTestName('投资记录-已还款')
      data1={"token"=>@token,"repay_type"=>"1","page"=>"1"}
      sql1="select * from
       (select invests.* ,
               invests.interest as amount_interest,
               sum(case invest_receives.done when 1 then invest_receives.amount_interest else 0 end) as invest_received_amount ,
               invests.interest - sum(case invest_receives.done when 1 then invest_receives.amount_interest else 0 end) as invest_unreceived_amount
        from invests, invest_receives, loans
        where invests.user_id = '#{@user_id}'
          and invests.loan_id = loans.id and invests.id = invest_receives.invest_id
          and case invests.loan_repay_status when 'ALL' then 1 else 0 end = 1
        group by invests.id order by

               case when 1 = 1 then invests.last_repay_date end desc,
               case when 1 = 0 then invests.create_time end desc
     )
     as t limit 20 offset 0 "
      path='.data'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
      result=asskeylist(jsondata1,sqldata1,["id","annualized_rate","amount","invest_received_amount","invest_unreceived_amount"])
      result1=asskey(jsondata1,sqldata1,["amount_interest",:interest])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字invest_id'
      @html.add_to_report(result,test)
      test = '检查关键字amount_interest'
      @html.add_to_report(result1,test)
    end
  end


  #未完成
  def test_wrong
    begin
      @html.newTestName('投资记录-参数为空')
      data1={}
      path='.error.msg'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      result= "token 失效".eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查error=token 失效'
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong1
    begin
      @html.newTestName('投资记录-参数值为空')
      data1={"token"=>"","repay_type"=>"","page"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      result= "token 失效".eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查error=token 失效'
      @html.add_to_report(result,test)
    end
  end


end