


class Testaccount_reward<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_reward')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000069","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
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
    sql1="select * from account_rewards where user_id = '#{@user_id}' and ( status = 'ACTIVE' or status = 'CREATED') order by status desc,CASE WHEN (status = 'ACTIVE' or status ='CREATED' ) THEN end_date end asc ,CASE WHEN status = 'USED'  THEN used_time  end desc,CASE WHEN status = 'EXPIRED' THEN expired_time end desc limit 20 offset 0   "
    path='.data'
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
    sql1="select * from account_rewards where user_id = '#{@user_id}' and ( status = NULL or status = 'CREATED') order by status desc,CASE WHEN (status = 'ACTIVE' or status ='CREATED' ) THEN end_date end asc ,CASE WHEN status = 'USED'  THEN used_time  end desc,CASE WHEN status = 'EXPIRED' THEN expired_time end desc limit 20 offset 0   "
    path='.data'
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
    sql1="select * from account_rewards where user_id = '#{@user_id}' and ( status = NULL or status = 'USED') order by status desc,CASE WHEN (status = 'ACTIVE' or status ='CREATED' ) THEN end_date end asc ,CASE WHEN status = 'USED'  THEN used_time  end desc,CASE WHEN status = 'EXPIRED' THEN expired_time end desc limit 20 offset 0  "
    path='.data'
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
    sql1="select * from account_rewards where user_id = '#{@user_id}' and ( status = NULL or status = 'EXPIRED') order by status desc,CASE WHEN (status = 'ACTIVE' or status ='CREATED' ) THEN end_date end asc ,CASE WHEN status = 'USED'  THEN used_time  end desc,CASE WHEN status = 'EXPIRED' THEN expired_time end desc limit 20 offset 0   "
    path='.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字reward_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  #未完成
  def test_wrong
    @html.newTestName('我的抵现券-参数为空')
    data1={}
    path='.error.msg'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    test = '检查error=token 失效'
    result= "token 失效".eql?jsondata1
    @html.add_to_report(result,test)
  end

  #未完成
  def test_wrong1
    @html.newTestName('我的抵现券-参数值为空')
    data1={"token"=>"","type"=>"","page"=>""}
    path='.error.msg'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    test = '检查error=token 失效'
    result= "token 失效".eql?jsondata1
    @html.add_to_report(result,test)
  end


end