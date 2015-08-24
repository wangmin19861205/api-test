require 'test/unit'
require_relative "../iframe/http_methods"
require_relative '../iframe/resultdiy'
require_relative "../iframe/htmlclass"



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
    middlepath='.data.middle_loans.loans[]'
    middleloans=jsonlist reqbody,middlepath
    list=[]
    middleloans.each do |row|
      list.push(row["id"])
    end
    @id=list.sample
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
    @html.newTestName('项目详情-中期正常')
    data={"token"=>@token,"id"=>@id}
    puts @id
    sql="select * from loans where disabled = 0 and id = #{@id}"
    path='.data.loan'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    test = '检查关键字:项目uninvest_amount'
    result=asskey(jsondata,sqldata,["uninvest_amount",:uninvest_amount])
    @html.add_to_report(result,test)
  end


end