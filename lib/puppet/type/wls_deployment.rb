require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_deployment) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a cluster in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_deployment' }
      wlst template('puppet:///modules/orawls/providers/wls_deployment/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_deployment/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_deployment/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_deployment/destroy.py.erb', binding)
    end

    parameter :name
    parameter :domain
    parameter :deployment_name
    parameter :localpath
    parameter :planpath
    parameter :timeout

    property :target
    property :targettype
    property :deploymenttype
    property :versionidentifier
    parameter :remote
    parameter :upload
    property :stagingmode

    add_title_attributes(:deployment_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
