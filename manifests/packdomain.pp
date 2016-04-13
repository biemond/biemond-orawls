# == Define: orawls::packdomain
#
# pack a new weblogic domain
##
define orawls::packdomain (
  $domain_name                = undef,
  $version                    = $::orawls::weblogic::version,  # 1036|1111|1211|1212|1213|1221
  $weblogic_home_dir          = $::orawls::weblogic::weblogic_home_dir, # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = $::orawls::weblogic::middleware_home_dir, # /opt/oracle/middleware11gR1
  $jdk_home_dir               = $::orawls::weblogic::jdk_home_dir, # /usr/java/jdk1.7.0_45
  $wls_domains_dir            = $::orawls::weblogic::wls_domains_dir,
  $os_user                    = $::orawls::weblogic::os_user, # oracle
  $os_group                   = $::orawls::weblogic::os_group, # dba
  $download_dir               = $::orawls::weblogic::download_dir, # /data/install
  $log_output                 = $::orawls::weblogic::log_output, # true|false
)
{
  # Must include domain_name
  unless $domain_name {
    fail('A domain is needed to pack it.')
  }

  if ( $wls_domains_dir == undef or $wls_domains_dir == '') {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  if ( $version == 1221 ) {
    $bin_dir = "${middleware_home_dir}/oracle_common/common/bin/pack.sh"
  } else {
    $bin_dir = "${weblogic_home_dir}/common/bin/pack.sh"
  }

  $exec_path   = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"
  $packCommand = "${bin_dir} -domain=${domains_dir}/${domain_name} -template=${download_dir}/domain_${domain_name}.jar -template_name=domain_${domain_name} -log=${download_dir}/domain_${domain_name}.log -log_priority=INFO"

  exec { "pack domain ${domain_name} ${title}":
    command     => $packCommand,
    creates     => "${download_dir}/domain_${domain_name}.jar",
    path        => $exec_path,
    user        => $os_user,
    group       => $os_group,
    logoutput   => $log_output,
    environment => "JAVA_HOME=${jdk_home_dir}",
  }
}
