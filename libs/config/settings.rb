require 'settingslogic'

class Settings<Settingslogic
  source File.dirname(File.dirname(__FILE__))+"/config/config.yml"
  #namespace "test"
  namespace "defaults"
  load!
end



#自定义config方法
def config
  return @config if @config
  config_path=File.expand_path("../???.yml",__FILE__)
  @config=YAML.load_file(config_path)
end




