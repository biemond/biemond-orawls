require File.dirname(__FILE__) + '/../../orawls_core'


module Puppet
  Type.newtype(:wls_server) do
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
      wlst_action = 'create'
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_server/create.py.erb', binding)
    end

    on_modify do | command_builder |
      wlst_action = 'modify'
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
    parameter :timeout

    property :tunnelingenabled

    property :trust_keystore_file
    property :custom_identity_keystore_filename
    property :custom_identity_alias

    property :ssllistenport
    property :sslenabled
    property :listenaddress
    property :listenport
    property :listenportenabled
    property :machine
    property :classpath
    property :arguments
    property :bea_home
    property :logintimeout

    property :frontendhost
    property :frontendhttpport
    property :frontendhttpsport

    property :logfilename
    property :log_file_min_size
    property :log_number_of_files_limited
    property :log_filecount
    property :log_rotationtype
    property :log_rotate_logon_startup
    property :log_datasource_filename
    property :log_redirect_stdout_to_server
    property :log_redirect_stderr_to_server
    property :log_date_pattern
    property :log_stdout_severity
    property :log_log_file_severity

    property :log_http_filename
    property :log_http_format_type
    property :log_http_format
    property :log_http_file_count
    property :log_http_number_of_files_limited

    property :sslhostnameverificationignored
    property :two_way_ssl
    property :client_certificate_enforced
    property :jsseenabled
    property :default_file_store
    property :max_message_size
    property :restart_max
    property :weblogic_plugin_enabled

    property :custom_identity
    property :useservercerts
    property :sslhostnameverifier

    property :auto_restart
    property :autokillwfail

    property :server_parameters

    add_title_attributes(:server_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
