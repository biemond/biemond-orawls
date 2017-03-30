require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_user) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage user in an WebLogic Secuirty Realm.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_user' }
      wlst template('puppet:///modules/orawls/providers/wls_user/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name}"
      template('puppet:///modules/orawls/providers/wls_user/create_modify.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_user/create_modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_user/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :user_name
    parameter :password
    parameter :timeout
    property :realm
    property :authenticationprovider
    property :description

    add_title_attributes(:user_name) do
      /^((.*?\/)?(.*)?)$/
    end

  end
end
