



class Testtrusteeship_deduct_cardbankinfo<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('trusteeship_deduct_cardbankinfo')
    url="http://rpc.wangmin.test.zrcaifu.com/trusteeship/deduct/allbankinfos"
    @url="http://rpc.wangmin.test.zrcaifu.com/trusteeship/deduct/cardbankinfo"
    banklist=jsonlist httpget(url),'.data'
    list=[]
    banklist.each do |row|
      list.push(row["bankname"])
    end
    @bankname=list.sample
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
    @html.newTestName('单个充值银行信息-正常')
    data1={"bankname"=>@bankname}
    sql1="select * from umbpay_bankinfos where type = 'DEDUCT' and bankname = '#{@bankname}'"
    path='.data'
    reqbody=httppost(@url,data1)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字:银行id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end


end