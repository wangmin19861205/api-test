

class Testinvest_create<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('invest_create')
    projectdatas=Resultdiy.new(@conn.sqlquery("select * from loans where disabled = 0 and status='INVEST' and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and invest_open_time < now() order by case loan_period when 'SHORT' then 1 when 'MIDDLE' then 2 when 'LONG' then 3 else 4 end asc , invest_open_time asc")).result_to_list
    loansid=[]
    projectdatas.each do |data|
      loansid.push(data[:id])
    end
    @id=loansid.sample
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13600000023","password"=>"123456"}
    reqbody= httppost(url,data)
    @token=jsonlist reqbody,'.token'
    @user_id=jsonlist reqbody,'.user.id'
    @url="http://rpc.wangmin.test.zrcaifu.com/mobileapitest/pay-deduct"
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
      @html.newTestName('创建投资-正常')
      data={"token"=>@token,"loan_id"=>'700000909',"amount"=>"1000","reward_id"=>"65000627","copopn_id"=>""}
      path='.error'
      reqbody=httppost(@url,data)
      puts reqbody
      jsondata=jsonlist reqbody,path
      result=nil.equal?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字error为空'
      @html.add_to_report(result,test)
    end
  end



=begin
  #未完成,没有处理，直接返回的0，0
  def test_wrong
    begin
      @html.newTestName('创建投资-参数为空')
      data={}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result='参数错误'.equal?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字error'
      @html.add_to_report(result,test)
    end
  end


  def test_wrong1
    begin
      @html.newTestName('创建投资-参数值为空')
      data={"token"=>'',"loan_id"=>'',"amount"=>"","reward_id"=>"","copopn_id"=>""}
      path='.error.msg'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result='参数错误'.equal?jsondata
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字error'
      @html.add_to_report(result,test)
    end
  end
=end


end
