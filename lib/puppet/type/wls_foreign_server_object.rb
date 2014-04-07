require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_foreign_server_object) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a foreign server object in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      wlst template('puppet:///modules/orawls/providers/wls_foreign_server_object/index.py.erb', binding)
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server_object/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server_object/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server_object/destroy.py.erb', binding)
    end

    def self.title_patterns
      identity = lambda {|x| x}
      [
        [
          /^((.*):(.*):(.*))$/,
          [
            [ :name, identity ],
            [ :jmsmodule, identity ],
            [ :foreign_server, identity ],
            [ :object_name, identity ],
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
    parameter :foreign_server
    parameter :object_name
    property  :object_type
    property  :remotejndiname
    property  :localjndiname

  private 

    def remotejndiname
       self[:remotejndiname]
    end

    def localjndiname
       self[:localjndiname]
    end

    def foreign_server
       self[:foreign_server]
    end

    def jmsmodule
       self[:jmsmodule]
    end

    def object_name
       self[:object_name]
    end

    def object_type
       self[:object_type]
    end

  end
end
