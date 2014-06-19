require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  newtype(:wls_cluster) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc "This resource allows you to manage a cluster in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_cluster"}
      wlst template('puppet:///modules/orawls/providers/wls_cluster/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_cluster/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_cluster/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_cluster/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :cluster_name
    property  :servers
    property  :migrationbasis
    property  :migration_datasource
    property  :migration_table_name
    property  :messagingmode
    property  :datasourceforjobscheduler
    property  :unicastbroadcastchannel
    property  :multicastaddress
    property  :multicastport

    add_title_attributes( :cluster_name) do 
      /^((.*\/)?(.*)?)$/
    end

  end
end
