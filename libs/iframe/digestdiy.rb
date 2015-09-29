require 'digest'
require 'base64'

###
module Digestdiy
  def md5diy string
    Digest::MD5.hexdigest(string)
  end

  def shadiy string
    Digest::SHA1.hexdigest(string)
  end

  def base64enconde string
    Base64.encode64(string)
  end

  def base64deconde string
    Base64.decode64(string)
  end
end


