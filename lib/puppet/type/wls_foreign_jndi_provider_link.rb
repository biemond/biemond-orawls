require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_foreign_jndi_provider_link) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a datasource in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_foreign_jndi_provider_link' }
      wlst template('puppet:///modules/orawls/providers/wls_foreign_jndi_provider_link/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_jndi_provider_link/create_modify.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_jndi_provider_link/create_modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_jndi_provider_link/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :link_name
    parameter :provider_name

    property  :local_jndi_name
    property  :remote_jndi_name

    add_title_attributes(:provider_name, :link_name) do
      /^((.*\/)?(.*):(.*))$/
    end

  end
end
