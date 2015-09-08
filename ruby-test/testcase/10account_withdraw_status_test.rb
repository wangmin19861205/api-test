


class Testaccount_withdraw_status<Test::Unit::TestCase
  include Httpmethod
  def setup
    @conn=MyDB.new "rui_site"
    @test_environment = 'QA'
    @html = HTMLReport.new()
    @report = @html.createReport1('account_withdraw_status')
    url="http://rpc.wangmin.test.zrcaifu.com/login"
    data={"name"=>"13500000045","password"=>"123456"}
    @token=jsonlist httppost(url,data),'.data.token'
    @url="http://rpc.wangmin.test.zrcaifu.com/account/withdraw/status"
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
    @html.newTestName('提现状态-处理中')
    data={"token"=>@token,"id"=>"11319"}
    sql="SELECT aj.user_id,aj.amount,aw.bankname,aw.cardno,aj.accepted,aj.done,aj.isok ,aj.status  FROM account_journals aj, account_withdraws aw   WHERE aj.table_id = aw.id  and aj.id = '11319' AND aj.table_name = 'account_withdraws' "
    path='.data.record'
    reqbody=httppost(@url,data)
    sqldata=Resultdiy.new(@conn.sqlquery(sql)).result_to_list
    result = assreqbody_sqlkey(reqbody,sqldata,path)
    test = '检查json与数据库data交集key的值对比'
    @html.add_to_report(result,test)
    end
  end