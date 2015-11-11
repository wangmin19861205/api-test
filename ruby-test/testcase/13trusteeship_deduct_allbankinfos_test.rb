


class Testtrusteeship_deduct_allbankinfos<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('trusteeship_deduct_allbankinfos')
    @url=ENV["rpc"]+"trusteeship/deduct/allbankinfos"
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
    @html.newTestName('全部代扣充值银行-正常')
    sql1="select * from umbpay_bankinfos where type = 'DEDUCT'"
    path='.bankinfos'
    reqbody=httpget(@url)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字:银行id'
    result=asskeylist(jsondata1,sqldata1,["id","bankname"])
    @html.add_to_report(result,test)
  end


end