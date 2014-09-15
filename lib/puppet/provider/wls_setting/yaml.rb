require 'easy_type'

Puppet::Type.type(:wls_setting).provide(:yaml) do
  include EasyType::Provider

  desc 'Manage wls settings through yaml file'

  mk_resource_methods

  def flush
    merge_configuration
    write_yaml
  end

private

  def merge_configuration
    # Always write defaults because we cannot support more then one setting
    resource.class.configuration.merge!("#{name}"  => settings_for_resource)
  end

  def settings_for_resource
    # settings = resource.to_resource
    settings = resource.to_hash.reject { |key, _value| [:name, :provider, :loglevel].include?(key) }
    stringify_keys(settings)
  end

  def write_yaml
    open(resource.class.config_file, 'w+') { |f| YAML.dump(resource.class.configuration, f) }
  end

  def stringify_keys(hash)
    result = {}
    hash.each do |key, value|
      result[key.to_s] = value
    end
    result
  end

end
