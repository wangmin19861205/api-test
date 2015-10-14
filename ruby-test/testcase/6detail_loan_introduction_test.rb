

class Testdetail_loan_summary<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail_loan_introduction')
    projectdatas=Resultdiy.new(@conn.sqlquery("select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc")).result_to_list
    loansid=[]
    projectdatas.each do |data|
      loansid.push(data[:id])
    end
    puts loansid
    @id=loansid.sample
    @url="http://rpc.wangmin.test.zrcaifu.com/loan/detail/introduction"
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
      @html.newTestName('项目简介-正常')
      data={"id"=>"#{@id}"}
      sql="select loan_summary_json from loandetails where loanproposal_id = (select loanproposal_id from loans where id='#{@id}')"
      path='.loan_summary_json[].title'
      path1='.loan_summary_json'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path1
      if jsondata == nil
        sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
        result= jsondata == sqldata.empty?
      else
        jsondata=jsonlist reqbody,path
        sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
        jsondata1=JSON.parse(sqldata[0][:loan_summary_json])
        result=(jsondata == (jsonlist jsondata1,'.[].title'))
      end
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json与sql中json的title是否相等'
      @html.add_to_report(result,test)
    end
  end



  #未完成，参数为空或空值    未处理
  def test_wrong1
    begin
      @html.newTestName('项目简介-参数为空')
      data={}
      path='.loan_summary_json[].title'
      path1='.loan_summary_json'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path1
      if jsondata == nil
        sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
        result= jsondata == sqldata.empty?
      else
        jsondata=jsonlist reqbody,path
        sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
        jsondata1=JSON.parse(sqldata[0][:loan_summary_json])
        result=(jsondata == (jsonlist jsondata1,'.[].title'))
      end
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json与sql中json的title是否相等'
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong2
    begin
      @html.newTestName('项目简介-参数值为空')
      data={"id"=>""}
      sql="select loan_summary_json from loandetails where loanproposal_id = (select loanproposal_id from loans where id='#{@id}')"
      path='.loan_summary_json[].title'
      path1='.loan_summary_json'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path1
      if jsondata == nil
        sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
        result= jsondata == sqldata.empty?
      else
        jsondata=jsonlist reqbody,path
        sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
        jsondata1=JSON.parse(sqldata[0][:loan_summary_json])
        result=(jsondata == (jsonlist jsondata1,'.[].title'))
      end
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json与sql中json的title是否相等'
      @html.add_to_report(result,test)
    end
  end


end