require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  newtype(:wls_messaging_bridge) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a messaging bridge in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_jms_bridge_destination' }

      wlst template('puppet:///modules/orawls/providers/wls_messaging_bridge/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_messaging_bridge/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_messaging_bridge/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_messaging_bridge/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :bridge_name

    property :asyncenabled
    property :batchinterval
    property :batchsize
    property :durabilityenabled
    property :idletimemax
    property :preservemsgproperty
    property :qosdegradationallowed
    property :qos
    property :reconnectdelayincrease
    property :reconnectdelaymax
    property :reconnectdelaymin
    property :selector
    property :started
    property :transactiontimeout
    property :sourcedestination
    property :targetdestination
    property :target
    property :targettype

    add_title_attributes(:bridge_name) do
      /^((.*\/)?(.*)?)$/
    end
  end
end

