require_relative '../iframe/http_methods'


class Testaccount_journals<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_journals')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/journals"
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
    @html.newTestName('交易明细-全部')
    data={"token"=>@token,"type"=>"ALL","page"=>"1"}
    sql="select * from account_journals where user_id = '2898945' and accepted =1 order by create_time desc limit 20 offset 0 "
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字journals_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right1
    @html.newTestName('交易明细-充值')
    data={"token"=>@token,"type"=>"RECHARGE","page"=>"1"}
    sql="select * from account_journals where user_id = '2898945' and accepted = 1 and table_name in ('account_recharges') order by create_time desc limit 20 offset 0  "
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字journals_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right2
    @html.newTestName('交易明细-投资')
    data={"token"=>@token,"type"=>"INVEST","page"=>"1"}
    sql="select * from account_journals where user_id = '2898945' and accepted = 1 and table_name in ('account_lender_pays') order by create_time desc limit 20 offset 0  "
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字journals_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right3
    @html.newTestName('交易明细-提现')
    data={"token"=>@token,"type"=>"WITHDRAW","page"=>"1"}
    sql="select * from account_journals where user_id = '2898945' and accepted = 1 and table_name in ('account_withdraws') order by create_time desc limit 20 offset 0   "
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字journals_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right4
    @html.newTestName('交易明细-提现处理中')
    data={"token"=>@token,"type"=>"WITHDRAW-PROCESSING","page"=>"1"}
    sql="select * from account_journals where user_id = '2898945' and table_name = 'account_withdraws' and accepted = 1 and isok = 0 and status ='PROCESSING' limit 10 offset 0 "
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字journals_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right5
    @html.newTestName('交易明细-收到还款')
    data={"token"=>@token,"type"=>"RECEIVE","page"=>"1"}
    sql="select * from account_journals where user_id = '2898945' and accepted = 1 and table_name in ('invest_receives', 'account_lender_receives_interest', 'account_lender_principal') order by create_time desc limit 20 offset 0"
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字journals_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right6
    @html.newTestName('交易明细-邀请')
    data={"token"=>@token,"type"=>"INVITE","page"=>"1"}
    sql="select * from account_journals where user_id = '2898945' and accepted = 1 and table_name in ('transfer_to_users') order by create_time desc limit 20 offset 0"
    path='.data.data'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字journals_id'
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end


end