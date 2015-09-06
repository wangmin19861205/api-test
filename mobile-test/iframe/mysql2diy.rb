require 'mysql2'
require_relative '../conf/settings'


class Mysqldiy
  def initialize(sql)
    @setting=Settings.new
    @conn=Mysql2::Client.new(
        :host=>@setting.DATABASE.host,
        :username=>@setting.DATABASE.username,
        :password=>@setting.DATABASE.password,
        :database=>@setting.DATABASE.database,
        :port=>@setting.DATABASE.port,
        :encoding=>@setting.DATABASE.chart)
    puts @setting.database
  end

  def sqlquery sql
    results=@conn.query(sql)
    arr=results.each(:as => :array) do |row|
    end
    return arr
  end

  def sqlupdate sql
    return @conn.query(sql)
  end

  def sqlupdateresult result,id
    sql="update testdata set result = '#{result}' where id = #{id}"
    @conn.query(sql)
  end

  def close
    @conn.close
  end
end

