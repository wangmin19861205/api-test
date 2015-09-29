require 'settingslogic'

class Settings<Settingslogic
  source File.dirname(File.dirname(__FILE__))+"/conf/apitest.yml"
  #namespace "test"
  namespace "defaults"
  load!
end



class SettingsMOBILE<Settingslogic
  source File.dirname(File.dirname(__FILE__))+"/conf/mobiletest.yml"
  #namespace "test"
  namespace "defaults"
  load!
end


class SettingsWEB<Settingslogic
  source File.dirname(File.dirname(__FILE__))+"/conf/webapp.yml"
  #namespace "test"
  namespace "defaults"
  load!
end


#自定义config方法
def config
  return @config if @config
  config_path=File.expand_path("../apitest.yml",__FILE__)
  @config=YAML.load_file(config_path)
end




