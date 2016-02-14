require File.dirname(__FILE__) + '/../../orawls_core'

module Puppet
  Type.newtype(:wls_virtual_target) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage virtual targets in an WebLogic 12.2.1 domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_virtual_target' }
      wlst template('puppet:///modules/orawls/providers/wls_virtual_target/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_virtual_target/create_modify.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_virtual_target/create_modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_virtual_target/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :virtual_target_name
    parameter :timeout
    property :channel
    property :target
    property :targettype
    property :virtual_host_names
    property :port
    property :portoffset
    property :uriprefix

    add_title_attributes(:virtual_target_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
