require File.dirname(__FILE__) + '/../../orawls_core'

require 'yaml'

module Puppet
  Type.newtype(:wls_setting) do
    include EasyType

    def self.get_wls_setting_file
      wls_setting_file = Facter.value('override_wls_setting_file')
      if wls_setting_file.nil?
        Puppet.debug 'wls_setting_file is default to /etc/wls_setting.yaml'
      else
        Puppet.debug "wls_setting_file is overridden to #{wls_setting_file}"
        return wls_setting_file
      end
      '/etc/wls_setting.yaml'
    end

    DEFAULT_FILE = get_wls_setting_file

    desc 'This resource allows you to set the defaults for all other wls types'

    to_get_raw_resources do
      resources_from_yaml
    end

    parameter :name
    property :user
    property :weblogic_home_dir
    property :weblogic_user
    property :connect_url
    property :weblogic_password
    property :post_classpath
    property :extra_arguments
    property :debug_module
    property :archive_path
    property :tmp_path

    property :custom_trust
    property :trust_keystore_file
    property :trust_keystore_passphrase

    property :use_default_value_when_empty

    def self.configuration
      @configuration
    end

    private

    def self.resources_from_yaml
      Puppet.debug '0 read_from_yaml '
      @configuration = read_from_yaml
      normalize(@configuration)
    end

    def self.config_file
      Pathname.new(DEFAULT_FILE).expand_path
    end

    def self.read_from_yaml
      if File.exist?(config_file)
        open(config_file) { |f| YAML.load(f) }
      else
        {}
      end
    end

    private

    def self.normalize(content)
      normalized_content = []
      content.each do | key, value|
        value[:name] = key
        normalized_content << with_hashified_keys(value)
      end
      normalized_content
    end

    def self.with_hashified_keys(hash)
      result = {}
      hash.each do |key, value|
        result[key.to_sym] = value
      end
      result
    end
  end
end
