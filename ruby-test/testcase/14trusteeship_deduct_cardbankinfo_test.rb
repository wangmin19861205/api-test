



class Testtrusteeship_deduct_cardbankinfo<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('trusteeship_deduct_cardbankinfo')
    url=ENV["rpc"]+"trusteeship/deduct/allbankinfos"
    banklist=jsonlist httpget(url),'.bankinfos'
    list=[]
    banklist.each do |row|
      list.push(row["bankname"])
    end
    @bankname=list.sample
    @url=ENV["rpc"]+"trusteeship/deduct/cardbankinfo"
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
      @html.newTestName('单个充值银行信息-正常')
      data1={"bankname"=>@bankname}
      sql1="select * from umbpay_bankinfos where type = 'DEDUCT' and bankname = '#{@bankname}'"
      path='.bankinfo'
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



  #未完成
  def test_wrong
    begin
      @html.newTestName('单个充值银行信息-参数为空')
      data1={}
      path='.bankinfo'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      result= nil.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字bankinfo=null'
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong1
    begin
      @html.newTestName('单个充值银行信息-参数值为空')
      data1={"bankname"=>""}
      path='.bankinfo'
      reqbody=httppost(@url,data1)
      jsondata1=jsonlist reqbody,path
      result= nil.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字bankinfo=null'
      @html.add_to_report(result,test)
    end
  end



end