# == Define: orawls::utils::fmwclusterjrf
#
# transform domain to a ADF cluster
##
define orawls::utils::fmwclusterjrf (
  $domain_name                = undef,
  $weblogic_password          = undef,
  $version                    = $::orawls::weblogic::version,  # 1036|1111|1211|1212|1213|1221
  $weblogic_home_dir          = $::orawls::weblogic::weblogic_home_dir, # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = $::orawls::weblogic::middleware_home_dir, # /opt/oracle/middleware11gR1
  $jdk_home_dir               = $::orawls::weblogic::jdk_home_dir, # /usr/java/jdk1.7.0_45
  $wls_domains_dir            = $::orawls::weblogic::wls_domains_dir,
  $adminserver_name           = 'AdminServer',
  $adminserver_address        = 'localhost',
  $adminserver_port           = 7001,
  $nodemanager_port           = 5556,
  $jrf_target_name            = undef,
  $opss_datasource_name       = undef,
  $weblogic_user              = 'weblogic',
  $os_user                    = $::orawls::weblogic::os_user, # oracle
  $os_group                   = $::orawls::weblogic::os_group, # dba
  $download_dir               = $::orawls::weblogic::download_dir, # /data/install
  $log_output                 = $::orawls::weblogic::log_output, # true|false
)
{
  # Must include domain_name
  unless $domain_name {
    fail('The domain must be passed if for fmw jrf.')
  }

  # Must include weblogic password
  unless $weblogic_password {
    fail('A weblogic password is needed to modify fmw jrf.')
  }

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
