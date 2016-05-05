# == Define: orawls::utils::fmwclusterjrf
#
# transform domain to a ADF cluster
##
define orawls::utils::fmwclusterjrf (
  $version                    = hiera('wls_version'               , 1111),  # 1036|1111|1211|1212|1213|1221
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $jdk_home_dir               = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $domain_name                = hiera('domain_name'),
  $wls_domains_dir            = hiera('wls_domains_dir'           , undef),
  $adminserver_name           = hiera('domain_adminserver'        , 'AdminServer'),
  $adminserver_address        = hiera('domain_adminserver_address', 'localhost'),
  $adminserver_port           = hiera('domain_adminserver_port'   , 7001),
  $nodemanager_port           = hiera('domain_nodemanager_port'   , 5556),
  $jrf_target_name            = undef,
  $opss_datasource_name       = undef,
  $weblogic_user              = hiera('wls_weblogic_user'         , 'weblogic'),
  $weblogic_password          = hiera('domain_wls_password'),
  $os_user                    = hiera('wls_os_user'), # oracle
  $os_group                   = hiera('wls_os_group'), # dba
  $download_dir               = hiera('wls_download_dir'), # /data/install
  $log_output                 = false, # true|false
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
      content => template('orawls/wlst/wlstexec/fmw/assignJrfToCluster.py.erb'),
      backup  => false,
      replace => true,
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
    }

    $exec_path = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

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
