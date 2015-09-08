



class Testdetail_loan_summary<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail_loan_summary')
    url1="http://rpc.wangmin.test.zrcaifu.com/listpage"
    reqbody=httpget(url1)
    path='.data[].loans[].loanproposal_id'
    loanproposal_ids=jsonlist reqbody,path
    @loanproposal_id=loanproposal_ids.sample
    @url="http://rpc.wangmin.test.zrcaifu.com/detail/loan_summary"
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
    @html.newTestName('项目简介-正常')
    data={"loanproposal_id"=>@loanproposal_id}
    sql="select loan_summary_json from loandetails where loanproposal_id = '#{@loanproposal_id}' "
    path='.data.loan_summary_json[].title'
    path1='.data.loan_summary_json'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path1
    test = '检查json与sql中json的title是否相等'
    if jsondata == nil
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result= jsondata == sqldata.empty?
    else
      jsondata=jsonlist reqbody,path
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      jsondata1=JSON.parse(sqldata[0][:loan_summary_json])
      result=(jsondata == (jsonlist jsondata1,'.[].title'))
    end
    @html.add_to_report(result,test)
  end


end