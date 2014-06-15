require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_workmanager_constraint) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage workmanager constraints in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { "action"=>"index","type"=>"wls_workmanager_constraint"}
      wlst template('puppet:///modules/orawls/providers/wls_workmanager_constraint/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_workmanager_constraint/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_workmanager_constraint/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_workmanager_constraint/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :workmanager_constraint_name
    property  :constrainttype
    property  :target
    property  :targettype
    property  :constraintvalue

    map_title_to_attributes(:name, [:domain, parse_domain_title], :workmanager_constraint_name) do 
     /^((.*\/)?(.*)?)$/
    end

  end
end
