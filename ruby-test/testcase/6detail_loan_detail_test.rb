


class Testdetail_loan_detail<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail_loan_detail')
    url1="http://rpc.wangmin.test.zrcaifu.com/listpage"
    reqbody=httpget(url1)
    path='.data[].loans[].loanproposal_id'
    loanproposal_ids=jsonlist reqbody,path
    @loanproposal_id=loanproposal_ids.sample
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
    data={"loanproposal_id"=>'5000847'}
    sql="select loan_detail_json from loandetails where loanproposal_id = '5000847'"
    path='.data.loan_detail_json[].title'
    path1='.data.loan_detail_json'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path1
    test = '检查json与sql中json的title是否相等'
    if jsondata == nil
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result= jsondata == sqldata.empty?
    else
      jsondata=jsonlist reqbody,path
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      jsondata1=JSON.parse(sqldata[0][:loan_detail_json])
      result=(jsondata == (jsonlist jsondata1,'.[].title'))
    end
    @html.add_to_report(result,test)
  end


end