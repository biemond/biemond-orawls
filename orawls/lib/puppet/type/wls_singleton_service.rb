require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_singleton_service) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to managed singleton services in a WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_singleton_service' }
      wlst template('puppet:///modules/orawls/providers/wls_singleton_service/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_singleton_service/create_modify.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_singleton_service/create_modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_singleton_service/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :singleton_service_name
    property :cluster
    property :class_name
    property :additional_migration_attempts
    property :millis_to_sleep_between_attempts
    property :notes
    property :constrained_candidate_servers
    property :user_preferred_server

    add_title_attributes(:singleton_service_name) do
      /^((.*\/)?(.*))$/
    end
  end
end
