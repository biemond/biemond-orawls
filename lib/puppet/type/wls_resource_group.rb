require File.dirname(__FILE__) + '/../../orawls_core'

module Puppet
  Type.newtype(:wls_resource_group) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage resource group in an WebLogic 12.2.1 domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_resource_group' }
      wlst template('puppet:///modules/orawls/providers/wls_resource_group/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_resource_group/create_modify.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_resource_group/create_modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_resource_group/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :resource_group_name
    parameter :timeout
    property :resource_group_template
    property :virtual_target

    add_title_attributes(:resource_group_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
