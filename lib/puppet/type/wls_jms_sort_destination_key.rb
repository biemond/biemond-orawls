require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_jms_sort_destination_key) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage the sort destination key in a JMS module of an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_jms_quota' }
      wlst template('puppet:///modules/orawls/providers/wls_jms_sort_destination_key/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info 'create'
      template('puppet:///modules/orawls/providers/wls_jms_sort_destination_key/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info 'modify'
      template('puppet:///modules/orawls/providers/wls_jms_sort_destination_key/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info 'destroy'
      template('puppet:///modules/orawls/providers/wls_jms_sort_destination_key/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jmsmodule
    parameter :key_name
    property  :key_type
    property  :property_name
    property  :sort_order
    parameter :timeout

    add_title_attributes(:jmsmodule, :key_name) do
      /^((.*\/)?(.*):(.*)?)$/
    end

  end
end
