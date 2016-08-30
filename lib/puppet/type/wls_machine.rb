require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_machine) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage machine in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_machine' }
      wlst template('puppet:///modules/orawls/providers/wls_machine/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_machine/create_modify.py.erb', binding)
    end

    on_modify  do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_machine/create_modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_machine/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :machine_name
    parameter :timeout

    property :machinetype
    property :nmtype
    property :listenaddress
    property :listenport

    add_title_attributes(:machine_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
