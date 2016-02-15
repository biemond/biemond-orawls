require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_group) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage group in an WebLogic Secuirty Realm.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_group' }
      wlst template('puppet:///modules/orawls/providers/wls_group/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_group/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_group/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_group/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :group_name
    parameter :timeout
    property :realm
    property :authenticationprovider
    property :users
    property :description

    add_title_attributes(:group_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
