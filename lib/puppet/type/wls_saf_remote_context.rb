require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  newtype(:wls_saf_remote_context) do
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
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_remote_context/create.py.erb', binding)
    end

    on_modify do | command_builder |
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

    #
    # Make sure the top level jms module is auto required
    #
    autorequire(:wls_jms_module) { jmsmodule }

  end
end
