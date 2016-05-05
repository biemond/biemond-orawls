require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_foreign_server) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage foreign servers in a JMS Module of an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_foreign_server' }
      wlst template('puppet:///modules/orawls/providers/wls_foreign_server/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server/create_modify.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server/create_modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jmsmodule
    parameter :foreign_server_name
    parameter :password
    parameter :timeout
    property :subdeployment
    property :defaulttargeting
    property :extraproperties
    property :initialcontextfactory
    property :connectionurl

    add_title_attributes(:jmsmodule, :foreign_server_name) do
      /^((.*\/)?(.*):(.*)?)$/
    end
  end
end
