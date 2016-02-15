require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_saf_error_handler) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a SAF Error Handler in a JMS Module of an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_saf_error_handler' }
      wlst template('puppet:///modules/orawls/providers/wls_saf_error_handler/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_error_handler/create.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_error_handler/modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_error_handler/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jmsmodule
    parameter :error_handler_name
    parameter :timeout
    property :errordestination
    property :logformat
    property :policy

    add_title_attributes(:jmsmodule, :error_handler_name) do
      /^((.*\/)?(.*):(.*)?)$/
    end
  end
end
