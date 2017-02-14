# == Define: orawls::packdomain
#
# pack a new weblogic domain
##
define orawls::packdomain (
  Integer $version            = $::orawls::weblogic::version,
  String $weblogic_home_dir   = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir = $::orawls::weblogic::middleware_home_dir,
  String $jdk_home_dir        = $::orawls::weblogic::jdk_home_dir,
  String $wls_domains_dir     = $::orawls::weblogic::wls_domains_dir,
  String $domain_name         = undef,
  String $os_user             = $::orawls::weblogic::os_user,
  String $os_group            = $::orawls::weblogic::os_group,
  String $download_dir        = $::orawls::weblogic::download_dir,
  Boolean $log_output         = $::orawls::weblogic::log_output,
)
{

  if ( $wls_domains_dir == undef or $wls_domains_dir == '') {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  if ( $version >= 1221 ) {
    $bin_dir = "${middleware_home_dir}/oracle_common/common/bin/pack.sh"
  } else {
    $bin_dir = "${weblogic_home_dir}/common/bin/pack.sh"
  }

  $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"
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
