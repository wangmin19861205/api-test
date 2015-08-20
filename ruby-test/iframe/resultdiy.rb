require_relative 'mysqldiy'
class Resultdiy
  def initialize result
    @result=result
  end

  def result_to_list
    @result.all
  end

  def result_count
    @result.count
  end

  def result_first *args, &block
    @result.first(*args, &block)
  end

end

=begin
require_relative 'http_methods'
include Httpmethod
url="http://rpc.wangmin.test.zrcaifu.com/listpage/more"
url1="http://rpc.wangmin.test.zrcaifu.com/login"
data1={"name"=>"13500000037","password"=>"123456"}
data={"type"=>"newuser","page"=>"1"}
jsondata=jsonlist httppost(url,data),["data","loans","loans"]
jsondata1=jsonlist httppost(url1,data1),["data","user"]
conn=MyDB.new "rui_site"
sql="select * from loans where disabled = 0 and special_loan is null and loan_tag is null and loan_type = 'NEWUSER_PROJECT' order by  case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,invest_open_time desc limit 3 offset 0"
sql1="select * from users where id = '2872338'"
sqldata=Resultdiy.new(conn.sqlquery(sql)).result_to_list
sqldata1=Resultdiy.new(conn.sqlquery(sql1)).result_to_list
conn.close
assall jsondata1,sqldata1
asslength jsondata1,sqldata1
asskey jsondata1,sqldata1,["id","id"]
p assall jsondata,sqldata
p asslength jsondata,sqldata
p asskey jsondata,sqldata,["id","id"]
=end


