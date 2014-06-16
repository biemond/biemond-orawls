require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_machine) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage machine in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { "action"=>"index","type"=>"wls_machine"}
      wlst template('puppet:///modules/orawls/providers/wls_machine/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_machine/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_machine/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_machine/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :machine_name

    property  :machinetype
    property  :nmtype
    property  :listenaddress
    property  :listenport

    map_title_to_attributes(:name, [:domain, parse_domain_title], :machine_name) do 
      /^((.*\/)?(.*)?)$/
    end
    
  end
end
