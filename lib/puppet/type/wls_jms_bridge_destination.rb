require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_jms_bridge_destination) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a jms bridge destination in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_jms_bridge_destination' }

      wlst template('puppet:///modules/orawls/providers/wls_jms_bridge_destination/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_bridge_destination/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_bridge_destination/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_bridge_destination/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :bridge_destination_name

    property :adapter
    property :classpath
    property :connectionfactoryjndi
    property :connectionurl
    property :destinationjndi
    property :destinationtype
    property :initialcontextfactory
    property :user_name
    property :password

    add_title_attributes(:bridge_destination_name) do
      /^((.*\/)?(.*)?)$/
    end
  end
end
