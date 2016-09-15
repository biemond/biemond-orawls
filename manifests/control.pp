# == Define: orawls::control
#
# Weblogic Server control, starts or stops a managed server
#
#  action        = start|stop
#  wlsServerType = admin|managed
#  wlsTarget     = Server|Cluster
#
define orawls::control (
  $middleware_home_dir         = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $weblogic_home_dir           = hiera('wls_weblogic_home_dir'),
  $jdk_home_dir                = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $wls_domains_dir             = hiera('wls_domains_dir', undef),
  $domain_name                 = hiera('domain_name'),
  $server_type                 = 'admin',  # admin|managed|ohs_standalone
  $target                      = 'Server', # Server|Cluster
  $server                      = 'AdminServer',
  $adminserver_address         = hiera('domain_adminserver_address'    , 'localhost'),
  $adminserver_port            = hiera('domain_adminserver_port'       , 7001),
  $adminserver_secure_listener = false,
  $nodemanager_secure_listener = true,
  $nodemanager_port            = hiera('domain_nodemanager_port'       , 5556),
  $action                      = 'start', # start|stop
  $weblogic_user               = hiera('wls_weblogic_user'             , 'weblogic'),
  $weblogic_password           = hiera('domain_wls_password'),
  $jsse_enabled                = hiera('wls_jsse_enabled'              , false),
  $custom_trust                = hiera('wls_custom_trust'              , false),
  $trust_keystore_file         = hiera('wls_trust_keystore_file'       , undef),
  $trust_keystore_passphrase   = hiera('wls_trust_keystore_passphrase' , undef),
  $extra_arguments             = '', # '-Dweblogic.security.SSL.minimumProtocolVersion=TLSv1',
  $os_user                     = hiera('wls_os_user'), # oracle
  $os_group                    = hiera('wls_os_group'), # dba
  $download_dir                = hiera('wls_download_dir'), # /data/install
  $log_output                  = false, # true|false
)
{
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
      extra_arguments             => $extra_arguments,
      ohs_standalone_server       => $ohs_standalone_server,
    }
  }
  else {
    wls_managedserver{"${title}:Server":
      ensure                      => $action,   #running|start|abort|stop
      target                      => $target,
      server_name                 => $server,
      domain_name                 => $domain_name,
      os_user                     => $os_user,
      weblogic_home_dir           => $weblogic_home_dir,
      weblogic_user               => $weblogic_user,
      weblogic_password           => $weblogic_password,
      jdk_home_dir                => $jdk_home_dir,
      adminserver_address         => $adminserver_address,
      adminserver_port            => $adminserver_port,
      adminserver_secure_listener => $adminserver_secure_listener,
    }
  }
}
