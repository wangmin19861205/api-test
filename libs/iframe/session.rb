require 'json'
class Sessiondiy
  class << self
    def rui(driver,type)
      cookies=driver.cookies
      $stderr.puts cookies.to_a
      bin_path=File.dirname(File.dirname(__FILE__))+'/libs/session-player-0.1.0-standalone.jar'
      key=cookies[:"rui-session"]
      $stderr.print "cookies=",cookies
      # $stderr.puts "to_a=",cookies.to_a
      if key
        key=URI.unescape key[:value]
        $stderr.puts "key",key
        str=`java -jar #{bin_path} "#{key}"`
        $stderr.puts "str",str
        if str and not str.empty?
          code = JSON.parse(str)
          $stderr.puts "str parse",code
          if type == "忘记密码"
            verify_code = code["noir"]["reset-password-captcha"]["captcha"]
          elsif type == "注册"
            verify_code = code["noir"]["register-secure"]["code"]
          else
            $stderr.print "无此类型session验证码 #{type}"
          end
          $stderr.print "verify_code=\"",verify_code,"\""
          return verify_code
        end
      end
    end
  end
end
