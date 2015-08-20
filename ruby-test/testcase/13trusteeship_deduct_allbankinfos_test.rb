require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testtrusteeship_deduct_allbankinfos<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('trusteeship_deduct_allbankinfos')
    @url="http://rpc.wangmin.test.zrcaifu.com/trusteeship/deduct/allbankinfos"
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
    path='.data'
    reqbody=httpget(@url)
    jsondata1=jsonlist reqbody,path
    sqldata1=Resultdiy.new(@conn.sqlquery(sql1)).result_to_list
    test = '检查关键字:银行id'
    result=asskey(jsondata1,sqldata1,["id",:id])
    @html.add_to_report(result,test)
  end


end