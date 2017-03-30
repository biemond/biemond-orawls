require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_server_channel) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage server in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.debug "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_server_channel' }
      wlst template('puppet:///modules/orawls/providers/wls_server_channel/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_server_channel/create_modify.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_server_channel/create_modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_server_channel/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :server
    parameter :channel_name
    parameter :timeout
    parameter :custom_identity_privatekey_passphrase

    property :protocol
    property :enabled
    property :listenport
    property :publicport
    property :listenaddress
    property :publicaddress
    property :httpenabled
    property :outboundenabled
    property :tunnelingenabled
    property :max_message_size
    property :custom_identity_alias
    property :two_way_ssl
    property :client_certificate_enforced
    property :channel_identity_customized

    add_title_attributes(:server, :channel_name) do
      /^((.*?\/)?(.*):(.*)?)$/
    end

  end
end
