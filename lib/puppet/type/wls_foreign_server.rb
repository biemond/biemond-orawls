require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_foreign_server) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage foreign servers in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      wlst template('puppet:///modules/orawls/providers/wls_foreign_server/index.py.erb', binding)
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server/destroy.py.erb', binding)
    end

    def self.title_patterns
      identity = lambda {|x| x}
      [
        [
          /^((.*):(.*))$/,
          [
            [ :name, identity ],
            [ :jmsmodule, identity ],
            [ :foreign_server_name, identity ]
          ]
        ],
        [
          /^([^=]+)$/,
          [
            [ :name, identity ]
          ]
        ]
      ]
    end

    parameter :name
    parameter :jmsmodule
    parameter :foreign_server_name
    parameter :password
    property  :subdeployment
    property  :defaulttargeting
    property  :extraproperties
    property  :extrapropertiesvalues
    property  :initialcontextfactory
    property  :connectionurl

  private 

    def password
       self[:password]
    end

    def initialcontextfactory
       self[:initialcontextfactory]
    end

    def connectionurl
       self[:connectionurl]
    end

    def extraproperties
       self[:extraproperties]
    end

    def extrapropertiesvalues
       self[:extrapropertiesvalues]
    end

    def foreign_server_name
       self[:foreign_server_name]
    end

    def jmsmodule
       self[:jmsmodule]
    end

    def subdeployment
       self[:subdeployment]
    end

    def defaulttargeting
       self[:defaulttargeting]
    end


  end
end
