require File.dirname(__FILE__) + '/../../orawls_core'

module Puppet
  Type.newtype(:wls_domain_partition) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage domain partitions in an WebLogic 12.2.1 domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_domain_partition' }
      wlst template('puppet:///modules/orawls/providers/wls_domain_partition/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_domain_partition/create_modify.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_domain_partition/create_modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_domain_partition/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :domain_partition_name
    parameter :timeout
    property :virtual_target
    property :root_file_system

    add_title_attributes(:domain_partition_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
