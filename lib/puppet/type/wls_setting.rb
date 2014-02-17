require 'easy_type'
require 'yaml'
#require 'ruby-debug'

module Puppet
  newtype(:wls_setting) do
    include EasyType

    DEFAULT_FILE = "~/.wls_setting.yaml"

    desc "This resource allows you to set the defaults for all other wls types"

    to_get_raw_resources do
      resources_from_yaml
    end

    parameter :name
    property  :user
    property  :weblogic_home_dir
    property  :weblogic_user
    property  :connect_url
    property  :weblogic_password

    def self.configuration
      @configuration
    end

  private

    def self.resources_from_yaml
      @configuration = read_from_yaml
      normalize(@configuration)
    end

    def self.config_file
      Pathname.new(DEFAULT_FILE).expand_path
    end


    def self.read_from_yaml
      if File.exists?(config_file)
        open(config_file){|f| YAML.load(f)}
      else
        Hash['default', {}]
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
