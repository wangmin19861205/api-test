


class Testdetail<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('detail')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    url1="http://rpc.wangmin.test.zrcaifu.com/listpage"
    reqbody=httpget(url1)
    path='.data[].loans[].id'
    loansid=jsonlist reqbody,path
    @id=loansid.sample
    @url="http://rpc.wangmin.test.zrcaifu.com/detail"
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
    @html.newTestName('项目详情-ID随机')
    data={"token"=>@token,"id"=>@id}
    sql="select id,title,annualized_rate,annualized_rate0,annualized_rate1,annualized_rate1,days_of_loan,min_invest_amount,uninvest_amount,loanproposal_id from loans  where disabled = 0 and id = #{@id}"
    path='.data.loan'
    reqbody=httppost(@url,data)
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查json与数据库data交集key的值对比'
    result=assreqbody_sqlkey(reqbody,sqldata,path)
    @html.add_to_report(result,test)
  end


end