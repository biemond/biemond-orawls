require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  newtype(:wls_server_template) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc "This resource allows you to manage server templates in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { "action"=>"index","type"=>"wls_server_template"}
      wlst template('puppet:///modules/orawls/providers/wls_server_template/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_server_template/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_server_template/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_server_template/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :server_template

    property  :ssllistenport
    property  :sslenabled
    property  :listenaddress
    property  :listenport
    property  :classpath
    property  :arguments

    add_title_attributes( :server_template) do 
       /^((.*\/)?(.*)?)$/
    end

  end
end
