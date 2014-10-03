require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  newtype(:wls_server) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage server in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { 'action' => 'index', 'type' => 'wls_server' }
      wlst template('puppet:///modules/orawls/providers/wls_server/index.py.erb', binding), environment
    end

    on_create do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_server/create.py.erb', binding)
    end

    on_modify do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_server/modify.py.erb', binding)
    end

    on_destroy do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_server/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :server_name

    parameter :custom_identity_keystore_passphrase
    parameter :custom_identity_privatekey_passphrase
    parameter :trust_keystore_passphrase

    property :custom_identity

    property :trust_keystore_file
    property :custom_identity_keystore_filename
    property :custom_identity_alias

    property :ssllistenport
    property :sslenabled
    property :listenaddress
    property :listenport
    property :machine
    property :classpath
    property :arguments

    property :logfilename
    property :log_file_min_size
    property :log_number_of_files_limited
    property :log_filecount
    property :log_rotationtype
    property :log_rotate_logon_startup

    property :sslhostnameverificationignored
    property :two_way_ssl
    property :client_certificate_enforced
    property :jsseenabled
    property :default_file_store

    add_title_attributes(:server_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
