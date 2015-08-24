require 'settingslogic'

class Settings<Settingslogic
  source File.dirname(File.dirname(__FILE__))+"/conf/application.yml"
  #namespace "test"
  namespace "defaults"
  load!
end



#自定义config
def config
  return @config if @config
  config_path=File.expand_path("../application.yml",__FILE__)
  @config=YAML.load_file(config_path)
end



