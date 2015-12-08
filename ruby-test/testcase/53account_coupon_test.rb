


class Testaccount_coupon<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('Testaccount_coupon')
    phone="13500000069"
    url=ENV["rpc"]+"login"
    data={"name"=>phone,"password"=>"123456"}
    path='.token'
    reqbody=httppost(url,data)
    @token=jsonlist reqbody,path
    @user_id=jsonlist reqbody,'.user.id'
    @url=ENV["rpc"]+"account/coupon"
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
      @html.newTestName('我的加息券-可用')
      data1={"token"=>@token,"type"=>"ACTIVE","page"=>"1"}
      sql1="select * from account_interest_coupons
     where user_id = '#{@user_id}' and (status = 'ACTIVE' or status = 'CREATED')
     order by status desc,
        CASE WHEN (status = 'ACTIVE' or status ='CREATED' ) THEN end_date end asc ,
        CASE WHEN status = 'USED'  THEN used_time  end desc,
        CASE WHEN status = 'EXPIRED' THEN expired_time end desc limit 20 offset 0 "
      path='.data'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
      result=asskey(jsondata1,sqldata1,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字coupon_id'
      @html.add_to_report(result,test)
    end
  end


  def test_right1
    begin
    @html.newTestName('我的加息券-新建')
    data1={"token"=>@token,"type"=>"CREATED","page"=>"1"}
    sql1="select * from account_interest_coupons
   where user_id = '#{@user_id}' and (status = 'nil' or status = 'CREATED')
   order by status desc,
      CASE WHEN (status = 'ACTIVE' or status ='CREATED' ) THEN end_date end asc ,
      CASE WHEN status = 'USED'  THEN used_time  end desc,
      CASE WHEN status = 'EXPIRED' THEN expired_time end desc limit 20 offset 0  "
    path='.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    result=asskey(jsondata1,sqldata1,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字coupon_id'
      @html.add_to_report(result,test)
    end
  end


  def test_right2
    begin
      @html.newTestName('我的加息券-已使用')
      data1={"token"=>@token,"type"=>"USED","page"=>"1"}
      sql1="select * from account_interest_coupons
     where user_id = '#{@user_id}' and (status = 'nil' or status = 'USED')
     order by status desc,
        CASE WHEN (status = 'ACTIVE' or status ='CREATED' ) THEN end_date end asc ,
        CASE WHEN status = 'USED'  THEN used_time  end desc,
        CASE WHEN status = 'EXPIRED' THEN expired_time end desc limit 20 offset 0   "
      path='.data'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
      result=asskey(jsondata1,sqldata1,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字coupon_id'
      @html.add_to_report(result,test)
    end
  end


  def test_right3
    begin
    @html.newTestName('我的加息券-已过期')
    data1={"token"=>@token,"type"=>"EXPIRED","page"=>"1"}
    sql1="select * from account_interest_coupons
   where user_id = '#{@user_id}' and (status = 'nil' or status = 'EXPIRED')
   order by status desc,
      CASE WHEN (status = 'ACTIVE' or status ='CREATED' ) THEN end_date end asc ,
      CASE WHEN status = 'USED'  THEN used_time  end desc,
      CASE WHEN status = 'EXPIRED' THEN expired_time end desc limit 20 offset 0   "
    path='.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    result=asskey(jsondata1,sqldata1,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字coupon_id'
      @html.add_to_report(result,test)
    end
  end



  #未完成
  def test_wrong
    begin
      @html.newTestName('我的加息券-参数为空')
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
      @html.newTestName('我的加息券-参数值为空')
      data1={"token"=>"","type"=>"","page"=>""}
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