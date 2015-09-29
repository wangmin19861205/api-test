



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
    begin
      @html.newTestName('用户代扣卡信息-已绑卡')
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"13500000069","password"=>"123456"}
      token=jsonlist httppost(url,data),'.token'
      data1={"token"=>token}
      sql1="select id , payment, cardno ,name, bankname,support_deduct as is_quick_payment_card from account_cards where user_id = '2899124' and deleted = 0 and deleted_time is null order by id desc "
      path='.card'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
      result=asskey(jsondata1,sqldata1,["id",:id])
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字:银行id'
      @html.add_to_report(result,test)
    end
  end


  def test_right1
    begin
      @html.newTestName('用户代扣卡信息-未绑卡')
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"13500000050","password"=>"123456"}
      token=jsonlist httppost(url,data),'.token'
      data1={"token"=>token}
      path='.card'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      result=nil.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json的card为空'
      @html.add_to_report(result,test)
    end
  end



  #未完成
  def test_wrong
    begin
      @html.newTestName('用户代扣卡信息-参数为空')
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={}
      token=jsonlist httppost(url,data),'.token'
      data1={"token"=>token}
      path='.card'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      result=nil.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json的card为空'
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong1
    begin
      @html.newTestName('用户代扣卡信息-参数值为空')
      url="http://rpc.wangmin.test.zrcaifu.com/login"
      data={"name"=>"","password"=>""}
      token=jsonlist httppost(url,data),'.token'
      data1={"token"=>token}
      path='.card'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      result=nil.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json的card为空'
      @html.add_to_report(result,test)
    end
  end



end