require File.dirname(__FILE__) + '/../../orawls_core'

require 'yaml'

module Puppet
  Type.newtype(:wls_setting) do
    include EasyType

    DEFAULT_FILE = '/etc/wls_setting.yaml'

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
    property :debug_module

    property :custom_trust
    property :trust_keystore_file
    property :trust_keystore_passphrase

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
