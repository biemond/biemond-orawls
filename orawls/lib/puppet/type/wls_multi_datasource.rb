require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  #
  Type.newtype(:wls_multi_datasource) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a multi datasource in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_multi_datasource' }

      wlst template('puppet:///modules/orawls/providers/wls_multi_datasource/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_multi_datasource/create_modify.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_multi_datasource/create_modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_multi_datasource/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :multi_datasource_name

    property :target
    property :targettype
    property :jndinames
    property :datasources
    property :algorithmtype
    property :testfrequency

    add_title_attributes(:multi_datasource_name) do
      /^((.*\/)?(.*)?)$/
    end

    autorequire(:wls_datasource) { datasources }

  end
end
