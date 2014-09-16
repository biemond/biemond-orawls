require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  newtype(:wls_server_channel) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage server in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_server_channel' }
      wlst template('puppet:///modules/orawls/providers/wls_server_channel/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_server_channel/create.py.erb', binding)
    end

    on_modify do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_server_channel/modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_server_channel/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :server
    parameter :channel_name

    property :protocol
    property :enabled
    property :listenport
    property :listenaddress
    property :publicaddress
    property :httpenabled
    property :outboundenabled
    property :tunnelingenabled

    add_title_attributes(:server, :channel_name) do
      /^((.*\/)?(.*):(.*)?)$/
    end

  end
end
