require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  newtype(:wls_jmsserver) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a jmsserver in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_jmsserver' }
      wlst template('puppet:///modules/orawls/providers/wls_jmsserver/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jmsserver/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jmsserver/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jmsserver/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jmsserver_name
    parameter :timeout
    property :persistentstore
    property :persistentstoretype
    property :target
    property :targettype
    property :bytes_maximum
    property :store_enabled
    property :allows_persistent_downgrade

    add_title_attributes(:jmsserver_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
