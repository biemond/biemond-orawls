require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_jms_connection_factory) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a CF in a JMS Module of an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_jms_connection_factory' }
      wlst template('puppet:///modules/orawls/providers/wls_jms_connection_factory/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_connection_factory/create_modify.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_connection_factory/create_modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_connection_factory/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jmsmodule
    parameter :connection_factory_name
    parameter :timeout
    property :jndiname
    property :localjndiname
    property :subdeployment
    property :defaulttargeting
    property :transactiontimeout
    property :xaenabled
    property :clientid
    property :clientidpolicy
    property :subscriptionsharingpolicy
    property :messagesmaximum
    property :reconnectpolicy
    property :loadbalancingenabled
    property :serveraffinityenabled
    property :attachjmsxuserid
    property :defaultdeliverymode
    property :defaultredeliverydelay

    add_title_attributes(:jmsmodule, :connection_factory_name) do
      /^((.*?\/)?(.*):(.*)?)$/
    end

  end
end
