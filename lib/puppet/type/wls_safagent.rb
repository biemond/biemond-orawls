require File.dirname(__FILE__) + '/../../orawls_core'

module Puppet
  Type.newtype(:wls_safagent) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a cluster in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_safagent' }
      wlst template('puppet:///modules/orawls/providers/wls_safagent/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_safagent/create_modify.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_safagent/create_modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_safagent/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :safagent_name
    parameter :timeout
    property :servicetype
    property :persistentstore
    property :persistentstoretype
    property :target
    property :targettype

    add_title_attributes(:safagent_name) do
      /^((.*?\/)?(.*)?)$/
    end

  end
end
