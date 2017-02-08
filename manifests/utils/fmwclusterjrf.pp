# == Define: orawls::utils::fmwclusterjrf
#
# transform domain to a ADF cluster
##
define orawls::utils::fmwclusterjrf (
  Integer $version                                        = $::orawls::weblogic::version,
  String $weblogic_home_dir                               = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir, 
  String $jdk_home_dir                                    = $::orawls::weblogic::jdk_home_dir,
  String $domain_name                                     = undef,
  Optional[String] $wls_domains_dir                       = $::orawls::weblogic::wls_domains_dir,
  String $adminserver_name                                = 'AdminServer',
  String $adminserver_address                             = 'localhost',
  Integer $adminserver_port                               = 7001,
  Integer $nodemanager_port                               = 5556,
  String $jrf_target_name                                 = undef,
  String $opss_datasource_name                            = undef,
  String $weblogic_user                                   = 'weblogic',
  String $weblogic_password                               = undef,
  String $os_user                                         = $::orawls::weblogic::os_user,
  String $os_group                                        = $::orawls::weblogic::os_group,
  String $download_dir                                    = $::orawls::weblogic::download_dir,
  Boolean $log_output                                     = $::orawls::weblogic::log_output,
)
{
  if ( $wls_domains_dir == undef or $wls_domains_dir == '') {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }
  $domain_dir = "${domains_dir}/${domain_name}"

  # check if the adf is already targeted to the cluster on this weblogic domain
  $found = jrf_cluster_configured($domain_dir, $jrf_target_name)

  if $found == undef {
    $continue = false
    notify { "orawls::utils::fmwclusterjrf ${title} ${version} continue false cause nill": }
  } else {
    if ($found) {
      $continue = false
    } else {
      notify { "orawls::utils::fmwclusterjrf ${title} ${version} continue true cause not exists": }
      $continue = true
    }
  }

  if ($continue) {
    #shutdown adminserver for offline WLST scripts
    orawls::control{"ShutdownAdminServerForJRF${title}":
      weblogic_home_dir   => $weblogic_home_dir,
      jdk_home_dir        => $jdk_home_dir,
      domain_name         => $domain_name,
      wls_domains_dir     => $domains_dir,
      server_type         => 'admin',
      target              => 'Server',
      server              => $adminserver_name,
      adminserver_address => $adminserver_address,
      adminserver_port    => $adminserver_port,
      nodemanager_port    => $nodemanager_port,
      action              => 'stop',
      weblogic_user       => $weblogic_user,
      weblogic_password   => $weblogic_password,
      os_user             => $os_user,
      os_group            => $os_group,
      download_dir        => $download_dir,
      log_output          => $log_output,
    }

    file { "${download_dir}/${title}_assignJrfToCluster.py":
      ensure  => present,
      content => epp('orawls/wlst/wlstexec/fmw/assignJrfToCluster.py.epp',
                     { 'weblogic_home_dir' => $weblogic_home_dir,
                       'domain_dir' => $domain_dir,
                       'jrf_target_name' => $jrf_target_name,
                       'opss_datasource_name' => $opss_datasource_name }),
      backup  => false,
      replace => true,
      mode    => lookup('orawls::permissions_group_restricted'),
      owner   => $os_user,
      group   => $os_group,
    }

    $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

    # reorder all apps,libraries, startup , shutdown
    exec { "execwlst assignJrfToCluster.py ${title}":
      command     => "${middleware_home_dir}/oracle_common/common/bin/wlst.sh ${download_dir}/${title}_assignJrfToCluster.py",
      environment => ["JAVA_HOME=${jdk_home_dir}"],
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      logoutput   => $log_output,
      require     => [File["${download_dir}/${title}_assignJrfToCluster.py"],
                      Orawls::Control["ShutdownAdminServerForJRF${title}"],]
    }

    #startup adminserver for offline WLST scripts
    orawls::control{"StartupAdminServerForJSF${title}":
      weblogic_home_dir   => $weblogic_home_dir,
      jdk_home_dir        => $jdk_home_dir,
      domain_name         => $domain_name,
      wls_domains_dir     => $domains_dir,
      server_type         => 'admin',
      target              => 'Server',
      server              => $adminserver_name,
      adminserver_address => $adminserver_address,
      adminserver_port    => $adminserver_port,
      nodemanager_port    => $nodemanager_port,
      action              => 'start',
      weblogic_user       => $weblogic_user,
      weblogic_password   => $weblogic_password,
      os_user             => $os_user,
      os_group            => $os_group,
      download_dir        => $download_dir,
      log_output          => $log_output,
      require             => Exec["execwlst assignJrfToCluster.py ${title}"],
    }
  }
}
