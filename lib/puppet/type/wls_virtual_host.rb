require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  Type.newtype(:wls_virtual_host) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage virtual host in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_virtual_host' }
      wlst template('puppet:///modules/orawls/providers/wls_virtual_host/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_virtual_host/create.py.erb', binding)
    end

    on_modify do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_virtual_host/modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_virtual_host/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :virtual_host_name
    parameter :timeout
    property :channel
    property :target
    property :targettype
    property :virtual_host_names

    add_title_attributes(:virtual_host_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
