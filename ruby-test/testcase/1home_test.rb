

class Testhome<Test::Unit::TestCase
  include Httpmethod
  def setup
    #初始化数据库连接site
    @conn=MyDB.new "rui_site"
    #初始化单个testclass的html报告
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('home')
    #初始化数据部分，如:获取token
    phone="13500000069"
    url=ENV["rpc"]+"login"
    data={"name"=>phone,"password"=>"123456"}
    path='.token'
    reqbody=httppost(url,data)
    @token=jsonlist reqbody,path
    #api请求的url
    @url=ENV["rpc"]+"home"
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
      #定义单个test方法的名字
      @html.newTestName('首页-未登录')
      #测试数据data====http请求的数据
      data={"token"=>""}
      #json解析的path
      #{"abc":"123","bbc": [{"abc1":"123", "abc2":{"abc3":"123"}}, {"abc4":"123","abc5":"123"}]}
      #path='.'获取全部
      #path='.bbc'获取bbc下的列表 [[{"abc1":"123", "abc2":{"abc3":"123"}}, {"abc4":"123","abc5":"123"}]]
      #path='.bbc[]'获取bbc列表中的值 [{"abc1":"123", "abc2":{"abc3":"123"}}, {"abc4":"123","abc5":"123"}]
      #path='.bbc[].abc2.abc3' 获取bbc列表中的abc2下的子json的abc3的值
      path='.loans'
      newpath='.newuser_loan'
      #需要用来对比数据的sql
      newsql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'NEWUSER_PROJECT' order by invest_open_time asc limit 1"
      opensql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      readysql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and invest_open_time > now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      vipopensql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'VIP_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      vipreadysql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'VIP_PROJECT' and invest_open_time > now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      #发起HTTP请求
      reqbody=httppost(@url,data)
      #解析返回的json数据
      jsondata=jsonlist reqbody,path
      newjsondata=jsonlist reqbody,newpath
      #发起数据库查询，并将查询结果转为列表,形式为[{:id=>1,name=>1},{:id=>2,name=>2}]
      newsqldata=Resultdiy.new(@conn.sqlquery(newsql)).result_to_list
      readysqldata=Resultdiy.new(@conn.sqlquery(readysql)).result_to_list
      opensqldata=Resultdiy.new(@conn.sqlquery(opensql)).result_to_list
      vipreadysqldata=Resultdiy.new(@conn.sqlquery(vipreadysql)).result_to_list
      vipopensqldata=Resultdiy.new(@conn.sqlquery(vipopensql)).result_to_list
      sqldata=opensqldata+readysqldata+vipopensqldata+vipreadysqldata+newsqldata
      alljsondata=jsondata.push(newjsondata)
      #数据验证,验证处理过的json与sql数据
      #目前提供assall asslength asskey等方法
      result=asskey(alljsondata,sqldata,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      #定义检查点的名字test，插入到html报告中
      test="检查关键字loan_id"
      #添加检查点测试结果与名字
      @html.add_to_report(result,test)
    end
    end

  def test_right1
    begin
      @html.newTestName('首页-已登录,已投资')
      data={"token"=>"#{@token}"}
      path='.loans'
      newpath='.new_user_loan'
      opensql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      readysql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and invest_open_time > now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      vipopensql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'VIP_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      vipreadysql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'VIP_PROJECT' and invest_open_time > now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      readysqldata=Resultdiy.new(@conn.sqlquery(readysql)).result_to_list
      opensqldata=Resultdiy.new(@conn.sqlquery(opensql)).result_to_list
      vipreadysqldata=Resultdiy.new(@conn.sqlquery(vipreadysql)).result_to_list
      vipopensqldata=Resultdiy.new(@conn.sqlquery(vipopensql)).result_to_list
      sqldata=opensqldata+readysqldata+vipopensqldata+vipreadysqldata
      result=asskey(jsondata,sqldata,["id",:id])
      result1= nil.eql?(jsonlist reqbody,newpath)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查json的new_user_loan为空"
      @html.add_to_report(result1,test)
      test="检查关键字loan_id"
      @html.add_to_report(result,test)
    end
    end

#未完成---预期：
  def test_wrong
    begin
      @html.newTestName('首页-未登录')
      data={}
      path='.loans'
      newpath='.newuser_loan'
      #需要用来对比数据的sql
      newsql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'NEWUSER_PROJECT' order by invest_open_time asc limit 1"
      opensql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      readysql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and invest_open_time > now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      vipopensql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'VIP_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      vipreadysql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'VIP_PROJECT' and invest_open_time > now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      newjsondata=jsonlist reqbody,newpath
      newsqldata=Resultdiy.new(@conn.sqlquery(newsql)).result_to_list
      readysqldata=Resultdiy.new(@conn.sqlquery(readysql)).result_to_list
      opensqldata=Resultdiy.new(@conn.sqlquery(opensql)).result_to_list
      vipreadysqldata=Resultdiy.new(@conn.sqlquery(vipreadysql)).result_to_list
      vipopensqldata=Resultdiy.new(@conn.sqlquery(vipopensql)).result_to_list
      sqldata=opensqldata+readysqldata+vipopensqldata+vipreadysqldata+newsqldata
      alljsondata=jsondata.push(newjsondata)
      result=asskey(alljsondata,sqldata,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test="检查关键字loan_id"
      @html.add_to_report(result,test)
    end
  end


#首页未处理，新手项目还款中的状态
end