require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_foreign_jndi_provider) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a datasource in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_foreign_jndi_provider' }
      wlst template('puppet:///modules/orawls/providers/wls_foreign_jndi_provider/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_jndi_provider/create_modify.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_jndi_provider/create_modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_jndi_provider/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :provider_name
    parameter :password

    property  :target
    property  :targettype
    property  :initial_context_factory
    property  :user
    property  :provider_properties
    property  :provider_url

    add_title_attributes(:provider_name) do
      /^((.*?\/)?(.*)?)$/
    end

  end
end
