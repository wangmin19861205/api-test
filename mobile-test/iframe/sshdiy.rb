require_relative '../conf/settings'
require 'net/ssh'


class MySSH
  class << self
    def sshconn sh
      @setting=Settings.new.SSH
      host=@setting.host
      username=@setting.username
      password=@setting.password
      port=@setting.port
      Net::SSH.start(host,username,:password => password,:port=> port) do |ssh|
        puts ssh.exec!(sh)
      end
    end
  end
end
