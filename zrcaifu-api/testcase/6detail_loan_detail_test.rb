require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



class Testdetail_loan_detail<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail_loan_detail')
    @url="http://rpc.wangmin.test.zrcaifu.com/detail/loan_detail"
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
    @html.newTestName('项目详情-详情-正常')
    data={"loanproposal_id"=>'5000832'}
    sql="select loan_detail_json from loandetails where loanproposal_id ='5000832'"
    path='.data.loan_detail_json[].title'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查2个json中的title'
    jsondata1=JSON.parse(sqldata[0][:loan_detail_json])
    result=(jsondata == (jsonlist jsondata1,'.[].title'))
    @html.add_to_report(result,test)
  end


end