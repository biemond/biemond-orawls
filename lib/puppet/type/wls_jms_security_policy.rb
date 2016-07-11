require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_jms_security_policy) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage security authorization policies in an WebLogic Security Realm.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_jms_security_policy' }
      wlst template('puppet:///modules/orawls/providers/wls_jms_security_policy/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name}"
      template('puppet:///modules/orawls/providers/wls_jms_security_policy/create.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name}"
      template('puppet:///modules/orawls/providers/wls_jms_security_policy/modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name}"
      template('puppet:///modules/orawls/providers/wls_jms_security_policy/destroy.py.erb', binding)
    end

    property  :policyexpression
    parameter :domain
    parameter :name
    parameter :jmsmodule
    parameter :destinationtype
    parameter :resourcename
    parameter :action
    parameter :authorizationprovider
    parameter :timeout

    add_title_attributes(:jmsmodule, :resourcename, :action) do
      /^((.*\/)?(.*):(.*):(.*))$/
    end

    autorequire(:wls_jms_queue) { "#{domain}/#{jmsmodule}:#{resourcename}" if destinationtype == :queue }
    autorequire(:wls_jms_topic) { "#{domain}/#{jmsmodule}:#{resourcename}" if destinationtype == :topic }

  end
end
