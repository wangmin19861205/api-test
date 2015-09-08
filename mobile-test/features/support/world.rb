


module Help
  def login_world(username,password)
    @home=Home.new(@driver)
    @home.in_home
    @home.in_account
    @login=Login.new(@driver)
    @login.login(username,password)
  end
end

  def clear_redis
    MySSH.sshconn('echo "FLUSHALL" | redis-cli')
  end

World(Help)

