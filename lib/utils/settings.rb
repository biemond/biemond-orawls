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
    configuration[environment]
  end

  def read_from_yaml
    if File.exist?(config_file)
      open(config_file) { |f| YAML.load(f) }
    else
      Hash['default', {}]
    end
  end
  
  def get_wls_setting_file
    wls_setting_file = Facter.value('override_wls_setting_file')
    if wls_setting_file.nil?
      Puppet.debug 'wls_setting_file is default to /etc/wls_setting.yaml'
    else
      Puppet.debug "wls_setting_file is overridden to #{wls_setting_file}"
      return wls_setting_file
    end
    '/etc/wls_setting.yaml'
  end
end
