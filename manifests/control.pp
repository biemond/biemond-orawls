# == Define: orawls::control
#
# Weblogic Server control, starts or stops a managed server
#
#  action        = start|stop
#  wlsServerType = admin|managed
#  wlsTarget     = Server|Cluster
##
define orawls::control (
  $domain_name,
  $weblogic_password,
  $server_type                 = 'admin',  # admin|managed
  $target                      = 'Server', # Server|Cluster
  $server                      = 'AdminServer',
  $adminserver_address         = 'localhost',
  $adminserver_port            = 7001,
  $nodemanager_secure_listener = true,
  $nodemanager_port            = 5556,
  $action                      = 'start', # start|stop
  $weblogic_user               = 'weblogic',
  $jsse_enabled                = false,
  $custom_trust                = false,
  $trust_keystore_file         = undef,
  $trust_keystore_passphrase   = undef,
)
{
  $version              = $::orawls::weblogic::version
  $middleware_home_dir  = $::orawls::weblogic::middleware_home_dir
  $weblogic_home_dir    = $::orawls::weblogic::weblogic_home_dir
  $wls_domains_dir      = $::orawls::weblogic::wls_domains_dir
  $wls_apps_dir         = $::orawls::weblogic::wls_apps_dir
  $jdk_home_dir         = $::orawls::weblogic::jdk_home_dir
  $os_user              = $::orawls::weblogic::os_user
  $os_group             = $::orawls::weblogic::os_group
  $download_dir         = $::orawls::weblogic::download_dir
  $log_output           = $::orawls::weblogic::log_output
  $oracle_base_home_dir = $::orawls::weblogic::oracle_base_home_dir
  $source               = $::orawls::weblogic::source
  $temp_directory       = $::orawls::weblogic::temp_directory

  if ( $wls_domains_dir == undef or $wls_domains_dir == '') {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  $domain_dir = "${domains_dir}/${domain_name}"

  if $server_type == 'admin' or $server_type == 'ohs_standalone' {
    $ohs_standalone_server = ($server_type == 'ohs_standalone')

    wls_adminserver{"${title}:AdminServer":
      ensure                      => $action,   #running|start|abort|stop
      server_name                 => $server,
      domain_name                 => $domain_name,
      domain_path                 => $domain_dir,
      os_user                     => $os_user,
      weblogic_home_dir           => $weblogic_home_dir,
      weblogic_user               => $weblogic_user,
      weblogic_password           => $weblogic_password,
      jdk_home_dir                => $jdk_home_dir,
      nodemanager_address         => $adminserver_address,
      nodemanager_port            => $nodemanager_port,
      nodemanager_secure_listener => $nodemanager_secure_listener,
      jsse_enabled                => $jsse_enabled,
      custom_trust                => $custom_trust,
      trust_keystore_file         => $trust_keystore_file,
      trust_keystore_passphrase   => $trust_keystore_passphrase,
      ohs_standalone_server       => $ohs_standalone_server,
    }
  }
  else {
    wls_managedserver{"${title}:Server":
      ensure              => $action,   #running|start|abort|stop
      target              => $target,
      server_name         => $server,
      domain_name         => $domain_name,
      os_user             => $os_user,
      weblogic_home_dir   => $weblogic_home_dir,
      weblogic_user       => $weblogic_user,
      weblogic_password   => $weblogic_password,
      jdk_home_dir        => $jdk_home_dir,
      adminserver_address => $adminserver_address,
      adminserver_port    => $adminserver_port,
    }
  }
}
