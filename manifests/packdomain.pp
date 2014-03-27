# == Define: orawls::packdomain
#
# pack a new weblogic domain
##
define orawls::packdomain (
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'     , undef), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir'   , undef), # /opt/oracle/middleware11gR1
  $jdk_home_dir               = hiera('wls_jdk_home_dir'          , undef), # /usr/java/jdk1.7.0_45
  $wls_domains_dir            = hiera('wls_domains_dir'           , undef),
  $domain_name                = hiera('domain_name'               , undef),
  $os_user                    = hiera('wls_os_user'               , undef), # oracle
  $os_group                   = hiera('wls_os_group'              , undef), # dba
  $download_dir               = hiera('wls_download_dir'          , undef), # /data/install
  $log_output                 = false, # true|false
)
{

  if ( $wls_domains_dir == undef ) {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir 
  }

  $exec_path   = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"
  $packCommand = "-domain=${domains_dir}/${domain_name} -template=${download_dir}/domain_${domain_name}.jar -template_name=domain_${domain_name} -log=${download_dir}/domain_${domain_name}.log -log_priority=INFO"

  exec { "pack domain ${domain_name} ${title}":
    command   => "${weblogic_home_dir}/common/bin/pack.sh ${packCommand}",
    creates   => "${download_dir}/domain_${domain_name}.jar",
    path      => $exec_path,
    user      => $os_user,
    group     => $os_group,
    logoutput => $log_output,
  }
}
