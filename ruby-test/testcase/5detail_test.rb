


class Testdetail<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail')
    url1="http://rpc.wangmin.test.zrcaifu.com/home"
    data={"token"=>""}
    reqbody=httppost(url1,data)
    path='.loans[].id'
    loansid=jsonlist reqbody,path
    @id=loansid.sample
    @url="http://rpc.wangmin.test.zrcaifu.com/loan/detail"
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
      @html.newTestName('项目详情-id随机')
      data={"id"=>@id}
      sql="select id,title,annualized_rate,annualized_rate0,annualized_rate1,annualized_rate1,days_of_loan,min_invest_amount,uninvest_amount,loanproposal_id from loans  where disabled = 0 and id = #{@id}"
      path='.loan'
      reqbody=httppost(@url,data)
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result=ass_with_sqlkey(reqbody,sqldata,path)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json与数据库data交集key的值对比'
      @html.add_to_report(result,test)
      end
    end


#未完成
  def test_wrong1
    begin
      @html.newTestName('项目详情-id为空')
      data={"id"=>''}
      path='.loan'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result= nil.eql?(jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
    test = '检查json的loan值为:null'
    @html.add_to_report(result,test)
    end
    end

#未完成
  def test_wrong2
    begin
      @html.newTestName('项目详情-参数为空')
      data={}
      path='.loan'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result= nil.eql?(jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查json的loan值为:null'
      @html.add_to_report(result,test)
    end
  end

#未完成
  def test_wrong3
    begin
    @html.newTestName('项目详情-参数值为空')
    data={"id"=>''}
    path='.loan'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    result= nil.eql?(jsondata)
    rescue Exception=>e
      result=[false,e.message]
    ensure
    test = '检查json的loan值为:null'
    @html.add_to_report(result,test)
    end
  end

end