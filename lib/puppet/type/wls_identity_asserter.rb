require File.dirname(__FILE__) + '/../../orawls_core'

module Puppet
  #
  Type.newtype(:wls_identity_asserter) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage Identity Asserters in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_identity_asserter' }
      wlst template('puppet:///modules/orawls/providers/wls_identity_asserter/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_identity_asserter/create_modify.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_identity_asserter/create_modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_identity_asserter/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :timeout
    parameter :order
    parameter :providerclassname
    parameter :attributes
    parameter :attributesvalues
    parameter :authentication_provider_name

    property :activetypes
    property :defaultmappertype

    add_title_attributes(:authentication_provider_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
