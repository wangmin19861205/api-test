


class Testaccount_message_category<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_message_category')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/message/category"
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
    @html.newTestName('获取全部消息-系统')
    data1={"token"=>@token,"type"=>"SYSTEM","page"=>"1"}
    sql1="select id, user_id, is_read, title, message_type , content, create_time, icon_isok from user_messages where disable = 0 and  user_id = '2898945' and ( message_type=  'SYSTEM' or message_type =  'nil' ) and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP') order by create_time desc   limit 10 offset 0"
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字message_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right1
    @html.newTestName('获取全部消息-投资')
    data1={"token"=>@token,"type"=>"INVEST","page"=>"1"}
    sql1="select id, user_id, is_read, title, message_type , content, create_time, icon_isok from user_messages where disable = 0 and  user_id = '2898945' and ( message_type=  'INVEST' or message_type =  'nil' ) and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP') order by create_time desc   limit 10 offset 0  "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字message_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right2
    @html.newTestName('获取全部消息-还款')
    data1={"token"=>@token,"type"=>"REPAY","page"=>"1"}
    sql1="select id, user_id, is_read, title, message_type , content, create_time, icon_isok from user_messages where disable = 0 and  user_id = '2898945' and ( message_type=  'REPAY' or message_type =  'nil' ) and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP') order by create_time desc   limit 10 offset 0 "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字message_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right3
    @html.newTestName('获取全部消息-债权转让')
    data1={"token"=>@token,"type"=>"CREDIT-ASSIGNMENT","page"=>"1"}
    sql1="select id, user_id, is_read, title, message_type , content, create_time, icon_isok from user_messages where disable = 0 and  user_id = '2898945' and ( message_type=  'CREDIT-ASSIGNMENT' or message_type =  'nil' ) and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP') order by create_time desc   limit 10 offset 0 "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字message_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right4
    @html.newTestName('获取全部消息-功能提醒 ')
    data1={"token"=>@token,"type"=>"FUNCTION-NOTIFICATION","page"=>"1"}
    sql1="select id, user_id, is_read, title, message_type , content, create_time, icon_isok from user_messages where disable = 0 and  user_id = '2898945' and ( message_type=  'FUNCTION-NOTIFICATION' or message_type =  'nil' ) and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP') order by create_time desc   limit 10 offset 0 "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字message_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right5
    @html.newTestName('获取全部消息-充值提现')
    data1={"token"=>@token,"type"=>"RECHARGE-WITHDRAW","page"=>"1"}
    sql1="select id, user_id, is_read, title, message_type , content, create_time, icon_isok from user_messages where disable = 0 and  user_id ='2898945' and ( message_type=  'RECHARGE' or message_type =  'WITHDRAW' ) and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP') order by create_time desc   limit 10 offset 0   "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字message_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right6
    @html.newTestName('获取全部消息-活动消息')
    data1={"token"=>@token,"type"=>"ACTIVITY-NOTIFICATION","page"=>"1"}
    sql1="select id, user_id, is_read, title, message_type , content, create_time, icon_isok from user_messages where disable = 0 and  user_id = '2898945' and ( message_type=  'ACTIVITY-NOTIFICATION' or message_type =  'nil' ) and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP') order by create_time desc   limit 10 offset 0 "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字message_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right7
    @html.newTestName('获取全部消息-用户积分')
    data1={"token"=>@token,"type"=>"MEMBER-SCORECARD-NOTIFICATION","page"=>"1"}
    sql1="select id, user_id, is_read, title, message_type , content, create_time, icon_isok from user_messages where disable = 0 and  user_id = '2898945' and ( message_type=  'MEMBER-SCORECARD-NOTIFICATION' or message_type =  'nil' ) and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'APP') order by create_time desc   limit 10 offset 0 "
    path='.data.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字message_id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end


end