require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_module) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc "This resource allows you to manage a JMS module in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_jms_module"}
      wlst template('puppet:///modules/orawls/providers/wls_jms_module/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_module/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_module/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_module/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jms_module_name
    property  :target
    property  :targettype

    add_title_attributes( :jms_module_name) do 
      /^((.*\/)?(.*)?)$/
    end

  end
end
