require File.dirname(__FILE__) + '/../../orawls_core'

module Puppet
  Type.newtype(:wls_migratable_target) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to managed migratable targets in a WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_migratable_target' }
      wlst template('puppet:///modules/orawls/providers/wls_migratable_target/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_migratable_target/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_migratable_target/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_migratable_target/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :migratable_target_name
    property :cluster
    property :number_of_restart_attempts
    property :seconds_between_restarts
    property :constrained_candidate_servers
    property :user_preferred_server
    property :migration_policy

    add_title_attributes(:migratable_target_name) do
      /^((.*\/)?(.*))$/
    end
  end
end
