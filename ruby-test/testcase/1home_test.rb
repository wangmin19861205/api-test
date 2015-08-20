require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



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
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    #api请求的url
    @url="http://rpc.wangmin.test.zrcaifu.com/home"
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
    path='.data.loans'
    newpath='.data.new_user_loan'
    #需要用来对比数据的sql
    newsql="select * from loans where disabled = 0 and special_loan is null and special_user_id is null and status = 'INVEST' and loan_type = 'NEWUSER_PROJECT' order by invest_open_time asc limit 1"
    readysql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type <> 'NEWUSER_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
    opensql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type <> 'NEWUSER_PROJECT' and invest_open_time > now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
    #发起HTTP请求
    reqbody=httppost(@url,data)
    #解析返回的json数据
    jsondata=jsonlist reqbody,path
    newjsondata=jsonlist reqbody,newpath
    #发起数据库查询，并将查询结果转为列表,形式为[{:id=>1,name=>1},{:id=>2,name=>2}]
    newsqldata=Resultdiy.new(@conn.sqlquery(newsql)).result_to_list
    readysqldata=Resultdiy.new(@conn.sqlquery(readysql)).result_to_list
    opensqldata=Resultdiy.new(@conn.sqlquery(opensql)).result_to_list
    sqldata=readysqldata+opensqldata+newsqldata
    alljsondata=jsondata.push(newjsondata)
    #定义检查点的名字test，插入到html报告中
    test="检查关键字loan_id"
    #数据验证,验证处理过的json与sql数据
    #目前提供assall asslength asskey等方法
    result=asskey(alljsondata,sqldata,["id",:id])
    #添加检查点测试结果与名字
    @html.add_to_report(result,test)
  end

  def test_right1
    @html.newTestName('首页-已登录,已投资')
    data={"token"=>"#{@token}"}
    path='.data.loans'
    newpath='.data.new_user_loan'
    readysql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type <> 'NEWUSER_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
    opensql="select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type <> 'NEWUSER_PROJECT' and invest_open_time > now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc"
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    readysqldata=Resultdiy.new(@conn.sqlquery(readysql)).result_to_list
    opensqldata=Resultdiy.new(@conn.sqlquery(opensql)).result_to_list
    sqldata=readysqldata+opensqldata
    test="检查json的new_user_loan为空"
    @html.add_to_report((nil.eql?(jsonlist reqbody,newpath)),test)
    test="检查关键字loan_id"
    result=asskey(jsondata,sqldata,["id",:id])
    @html.add_to_report(result,test)
  end



end