require 'sequel'
require_relative '../conf/settings'
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8


class MyDB
  def initialize webdb
    @setting=Settings.new.DATABASE
    host=@setting.host
    username=@setting.username
    password=@setting.password
    if webdb=="rui_site"
      database=@setting.database
    elsif webdb=="rui_admin"
      database=@setting.database_admin
    end
    port=@setting.port
    chart=@setting.chart
    @conn=Sequel.connect("mysql2://#{username}:#{password}@#{host}:#{port}/#{database}?encoding=#{chart}")
  end

  def sqlquery sql
    @conn[sql]
  end

  def update sql
    @conn.run(sql)
  end

  def delete sql
    @conn[sql].delete
  end


  def close
    @conn.disconnect
  end
end











