



class Testoverview<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('overview')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/overview"
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
    @html.newTestName('用户概览-正常')
    data={"token"=>@token}
    sql="select balance_total,receivable_interest,receivable_principal,accumulate_interest,available_reward,available_money,frozen_money_withdraw from `accounts` where user_id ='2898945'"
    path='.data'
    reqbody=httppost(@url,data)
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查json与数据库data交集key的值对比'
    result=assreqbody_sqlkey reqbody,sqldata,path
    @html.add_to_report(result,test)
  end

  def test_wrong
    @html.newTestName('用户概览-错误token')
    data={"token"=>"rui-session:5d28737b-ce8c1-43d0-b20c-799b54ffe12f"}
    path='.data.error.code'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    test = '检查json中的code=20000'
    @html.add_to_report(20000.eql?(jsondata),test)
  end

end