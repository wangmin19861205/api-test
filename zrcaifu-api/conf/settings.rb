require 'settingslogic'

class Settings<Settingslogic
  source File.dirname(File.dirname(__FILE__))+"/conf/application.yml"
  #namespace "test"
  namespace "defaults"
  load!
end


