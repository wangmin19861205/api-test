



class Testtrusteeship_deduct_usercard<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('trusteeship_deduct_usercard')
    @url="http://rpc.wangmin.test.zrcaifu.com/trusteeship/deduct/user-card"
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
    @html.newTestName('用户代扣卡信息-已绑卡')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    token=jsonlist httppost(url,data),'.data.token'
    data1={"token"=>token}
    sql1="select id , payment, cardno ,name, bankname,support_deduct as is_quick_payment_card from account_cards where user_id = '2898945' and deleted = 0 and deleted_time is null order by id desc "
    path='.data.card'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字:银行id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end

  def test_right1
    @html.newTestName('用户代扣卡信息-未绑卡')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000050","password"=>"123456"}
    token=jsonlist httppost(url,data),'.data.token'
    data1={"token"=>token}
    sql1="select id , payment, cardno ,name, bankname,support_deduct as is_quick_payment_card from account_cards where user_id = '2898945' and deleted = 0 and deleted_time is null order by id desc "
    path='.data.card'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    test = '检查json的card为空'
    result=nil.eql?jsondata1
    @html.add_to_report(result,test)
  end


end