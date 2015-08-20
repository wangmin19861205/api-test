require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testaccount_reward<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_reward')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/reward"
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
    @html.newTestName('我的抵现券-可用')
    data1={"token"=>@token,"type"=>"ACTIVE","page"=>"1"}
    sql1="select * from account_rewards where user_id = '2898945' and ( status = 'ACTIVE' or status = 'CREATED') order by status desc , expired_time desc limit 20 offset 0   "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字reward_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right1
    @html.newTestName('我的抵现券-新建')
    data1={"token"=>@token,"type"=>"CREATED","page"=>"1"}
    sql1="select * from account_rewards where user_id = '2898945' and ( status = 'CREATED' or status = 'nil') order by status desc , expired_time desc limit 20 offset 0   "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字reward_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right2
    @html.newTestName('我的抵现券-已使用')
    data1={"token"=>@token,"type"=>"USED","page"=>"1"}
    sql1="select * from account_rewards where user_id = '2898945' and ( status = 'USED' or status = 'nil') order by status desc , expired_time desc limit 20 offset 0   "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字reward_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right3
    @html.newTestName('我的抵现券-已过期')
    data1={"token"=>@token,"type"=>"EXPIRED","page"=>"1"}
    sql1="select * from account_rewards where user_id = '2898945' and ( status = 'EXPIRED' or status = 'nil') order by status desc , expired_time desc limit 20 offset 0  "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字reward_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end


end