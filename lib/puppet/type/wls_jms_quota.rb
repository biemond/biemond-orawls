require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_jms_quota) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a Quota in a JMS module of an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_jms_quota' }
      wlst template('puppet:///modules/orawls/providers/wls_jms_quota/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info 'create'
      template('puppet:///modules/orawls/providers/wls_jms_quota/create_modify.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info 'modify'
      template('puppet:///modules/orawls/providers/wls_jms_quota/create_modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info 'destroy'
      template('puppet:///modules/orawls/providers/wls_jms_quota/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jmsmodule
    parameter :quota_name
    parameter :timeout
    property :bytesmaximum
    property :messagesmaximum
    property :policy
    property :shared

    add_title_attributes(:jmsmodule, :quota_name) do
      /^((.*\/)?(.*):(.*)?)$/
    end

  end
end
