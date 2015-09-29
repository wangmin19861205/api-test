


class Testdetail_loan_detail<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail_loan_detail')
    url1="http://rpc.wangmin.test.zrcaifu.com/home"
    data={"token"=>""}
    reqbody=httppost(url1,data)
    path='.loans[].id'
    loansid=jsonlist reqbody,path
    @id=loansid.sample
    @url="http://rpc.wangmin.test.zrcaifu.com/loan/detail-more"
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
      @html.newTestName('项目详情-详情-正常')
      data={"id"=>"#{@id}"}
      sql="select loan_detail_json from loandetails where loanproposal_id = (select loanproposal_id from loans where id='#{@id}')"
      path='.loan_detail.loan_detail_json[].title'
      path1='.loan_detail.loan_detail_json'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path1
      if jsondata == nil
        sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
        result= jsondata == sqldata.empty?
      else
        jsondata=jsonlist reqbody,path
        sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
        jsondata1=JSON.parse(sqldata[0][:loan_detail_json])
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
  def test_right1
    begin
      @html.newTestName('项目详情-详情-title为空')
      data={"id"=>'700000463'}
      path1='.loan_detail.loan_detail_json'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path1
      result= (nil.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json与sql中json的title是否相等'
      @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong
    begin
      @html.newTestName('项目详情_详情-参数为空')
      data={}
      path1='.loan_detail.loan_detail_json'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path1
      result= (nil.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json是否为空'
      @html.add_to_report(result,test)
    end
  end


  #未完成,预期:
  def test_wrong1
    begin
      @html.newTestName('项目详情_详情-参数值为空')
      data={"id"=>''}
      path1='.loan_detail.loan_detail_json'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path1
      result= (nil.eql?jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json是否为空'
      @html.add_to_report(result,test)
    end
  end


end