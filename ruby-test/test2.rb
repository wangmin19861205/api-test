require_relative "iframe/http_methods"
require_relative 'iframe/resultdiy'
require_relative "iframe/htmlclass"
require_relative 'iframe/mysqldiy'
require_relative 'iframe/resultdiy'
include Httpmethod


p httppost("http://www.wangmin.test.zrcaifu.com/account/membership/checkin",{"rui-session"=>""})