# == Define: orawls::control
#
# Weblogic Server control, starts or stops a managed server
#
#  action        = start|stop
#  wlsServerType = admin|managed
#  wlsTarget     = Server|Cluster
#
define orawls::control (
  String $weblogic_home_dir                               = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir, 
  String $jdk_home_dir                                    = $::orawls::weblogic::jdk_home_dir,
  Optional[String] $wls_domains_dir                       = $::orawls::weblogic::wls_domains_dir,
  String $domain_name                                     = undef,
  String $os_user                                         = $::orawls::weblogic::os_user,
  String $os_group                                        = $::orawls::weblogic::os_group,
  String $download_dir                                    = $::orawls::weblogic::download_dir,
  Boolean $log_output                                     = $::orawls::weblogic::log_output,
  Enum['admin','managed','ohs_standalone'] $server_type   = 'admin',
  Enum['Server','Cluster'] $target                        = 'Server',
  String $server                                          = 'AdminServer',
  String $adminserver_address                             = 'localhost',
  Integer $adminserver_port                               = 7001,
  Boolean $adminserver_secure_listener                    = false,
  Integer $nodemanager_port                               = 5556,
  Boolean $nodemanager_secure_listener                    = true,
  Enum['start','stop','running','abort'] $action          = 'start', 
  String $weblogic_user                                   = 'weblogic',
  String $weblogic_password                               = undef,
  Boolean $jsse_enabled                                   = false,
  Boolean $custom_trust                                   = false,
  Optional[String] $trust_keystore_file                   = undef,
  Optional[String] $trust_keystore_passphrase             = undef,
  String $extra_arguments                                 = '', # '-Dweblogic.security.SSL.minimumProtocolVersion=TLSv1'
)
{
  if ( $wls_domains_dir == undef or $wls_domains_dir == '') {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  $domain_dir = "${domains_dir}/${domain_name}"

  if $server_type == 'admin' {
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
    }
  }
  elsif $server_type == 'ohs_standalone' {
    wls_ohsserver{"${title}:AdminServer":
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
