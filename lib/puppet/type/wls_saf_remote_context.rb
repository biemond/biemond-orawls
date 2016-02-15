require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_saf_remote_context) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a SAF remote contexts in a JMS Module of an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_saf_remote_context' }
      wlst template('puppet:///modules/orawls/providers/wls_saf_remote_context/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_remote_context/create.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_remote_context/modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_remote_context/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jmsmodule
    parameter :remote_context_name
    parameter :weblogic_password
    parameter :timeout
    property :weblogic_user
    property :connect_url

    add_title_attributes(:jmsmodule, :remote_context_name) do
      /^((.*\/)?(.*):(.*)?)$/
    end

  end
end
