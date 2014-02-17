require 'yaml'

module Settings

  def self.included(parent)
    parent.extend(Settings)
  end

  def setting_for(key)
    settings[key]
  end

  def configuration
    @configuration ||= read_from_yaml
  end

  def settings
    configuration['default']
  end

  def read_from_yaml
    if File.exists?(config_file)
      open(config_file){|f| YAML.load(f)}
    else
      Hash['default', {}]
    end
  end


end
