require File.dirname(__FILE__) + '/../../orawls_core'

module Puppet
  Type.newtype(:wls_domain_partition_resource_group_deployment) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage deployments in a resource group of a domain partition in an WebLogic 12.2.1 domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_domain_partition_resource_group_deployment' }
      wlst template('puppet:///modules/orawls/providers/wls_domain_partition_resource_group_deployment/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_domain_partition_resource_group_deployment/create_modify.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_domain_partition_resource_group_deployment/create_modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_domain_partition_resource_group_deployment/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :domain_partition_name
    parameter :resource_group_name
    parameter :deployment_name
    parameter :localpath
    parameter :planpath
    parameter :timeout
    parameter :remote
    parameter :upload

    property :deploymenttype
    property :versionidentifier
    property :stagingmode

    add_title_attributes(:domain_partition_name, :resource_group_name, :deployment_name) do
      /^((.*\/)?(.*):(.*):(.*)?)$/
    end

  end
end
