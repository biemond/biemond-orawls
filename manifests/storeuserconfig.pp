# == Define: orawls::storeuserconfig
#
# generic storeuserconfig wlst script
#
define orawls::storeuserconfig (
  $domain_name,
  $weblogic_password,
  $adminserver_address = 'localhost',
  $adminserver_port    = 7001,
  $user_config_dir     = undef, #'/home/oracle',
  $weblogic_user       = 'weblogic',
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

  # the py script used by the wlst*-
  file { "${download_dir}/${title}storeUserConfig.py":
    ensure  => present,
    path    => "${download_dir}/${title}storeUserConfig.py",
    content => template('orawls/wlst/storeUserConfig.py.erb'),
    backup  => false,
    replace => true,
    mode    => '0555',
    owner   => $os_user,
    group   => $os_group,
  }

  $javaCommand = 'java -Dweblogic.management.confirmKeyfileCreation=true -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning '
  $exec_path   = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

  exec { "execwlst ${title}storeUserConfig.py":
    command     => "${javaCommand} ${download_dir}/${title}storeUserConfig.py ${weblogic_password}",
    environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar", "JAVA_HOME=${jdk_home_dir}"],
    unless      => "ls -l ${user_config_dir}/${os_user}-${domain_name}-WebLogicConfig.properties",
    path        => $exec_path,
    user        => $os_user,
    group       => $os_group,
    logoutput   => $log_output,
    require     => File["${download_dir}/${title}storeUserConfig.py"],
  }
}
