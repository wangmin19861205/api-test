


module Help
  def login_world(username,password)
    home=Home.new(@driver)
    home.in_home
    home.in_account
    login=Login.new(@driver)
    login.login(username,password)
  end
end

  def clear_redis
    puts "清除redis"
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
  end

  def update_message_disable_read_false
    conn=MyDB.new("rui_site")
    conn.sqlquery("update user_messages set disable = 0,is_read = 0")
  end

  def delete_userinfo username
    conn=MyDB.new("rui_site")
    conn.delete("delete  from users where secure_phone='#{username}'")
  end

World(Help)

