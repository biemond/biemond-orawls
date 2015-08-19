require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  Type.newtype(:wls_dynamic_cluster) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a dynamic cluster in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_dynamic_cluster' }
      wlst template('puppet:///modules/orawls/providers/wls_dynamic_cluster/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_dynamic_cluster/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_dynamic_cluster/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_dynamic_cluster/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :cluster_name
    parameter :timeout
    property :server_name_prefix
    property :server_template_name
    property :nodemanager_match
    property :maximum_server_count
    property :calculated_listen_port

    add_title_attributes(:cluster_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
