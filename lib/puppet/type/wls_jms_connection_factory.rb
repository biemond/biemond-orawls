require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_connection_factory) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a CF in a JMS Module of an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_jms_connection_factory' }
      wlst template('puppet:///modules/orawls/providers/wls_jms_connection_factory/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_connection_factory/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_connection_factory/modify.py.erb', binding)
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
    property :subdeployment
    property :defaulttargeting
    property :transactiontimeout
    property :xaenabled
    property :clientidpolicy
    property :subscriptionsharingpolicy
    property :messagesmaximum
    property :reconnectpolicy
    property :loadbalancingenabled
    property :serveraffinityenabled
    property :attachjmsxuserid

    add_title_attributes(:jmsmodule, :connection_factory_name) do
      /^((.*\/)?(.*):(.*)?)$/
    end

  end
end
