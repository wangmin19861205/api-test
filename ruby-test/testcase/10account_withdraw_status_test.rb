


class Testaccount_withdraw_status<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_withdraw_status')
    phone="13500000069"
    url=ENV["rpc"]+"login"
    data={"name"=>phone,"password"=>"123456"}
    path='.token'
    reqbody=httppost(url,data)
    @token=jsonlist reqbody,path
    @url=ENV["rpc"]+"account/withdraw/status"
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
      @html.newTestName('提现状态-处理中')
      data={"token"=>@token,"id"=>"11319"}
      sql="SELECT aj.user_id,aj.amount,aw.bankname,aw.cardno,aj.accepted,aj.done,aj.isok ,aj.status  FROM account_journals aj, account_withdraws aw   WHERE aj.table_id = aw.id  and aj.id = '11319' AND aj.table_name = 'account_withdraws' "
      path='.record'
      reqbody=httppost(@url,data)
      sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
      result = ass_with_sqlkey(reqbody,sqldata,path)
    rescue Exception=>e
      result=[false,e.message]
    ensure
    test = '检查json与数据库data交集key的值对比'
    @html.add_to_report(result,test)
    end
  end


  #未完成
  def test_wrong
    begin
      @html.newTestName('提现状态-参数为空')
      data={}
      path='.record'
      path1='.error'
      reqbody=httppost(@url,data)
      jsondata=jsonlist reqbody,path
      result = nil.eql?jsondata
      jsondata1=jsonlist reqbody,path1
      result1 = nil.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字record=null'
      @html.add_to_report(result,test)
      test1 = '检查关键字error=null'
      @html.add_to_report(result1,test1)
    end
  end


  #未完成
  def test_wrong1
    begin
    @html.newTestName('提现状态-参数值为空')
    data={"token"=>'',"id"=>""}
    path='.record'
    path1='.error'
    reqbody=httppost(@url,data)
    jsondata=jsonlist reqbody,path
    result = nil.eql?jsondata
    jsondata1=jsonlist reqbody,path1
    result1 = nil.eql?jsondata1
    rescue Exception=>e
      result=[false,e.message]
    ensure
      test = '检查关键字record=null'
      @html.add_to_report(result,test)
      test1 = '检查关键字error=null'
      @html.add_to_report(result1,test1)
    end
  end



end