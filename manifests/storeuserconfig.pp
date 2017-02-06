# == Define: orawls::storeuserconfig
#
# generic storeuserconfig wlst script
#
define orawls::storeuserconfig (
  String $domain_name         = undef,
  String $weblogic_home_dir   = $::orawls::weblogic::weblogic_home_dir,
  String $jdk_home_dir        = $::orawls::weblogic::jdk_home_dir,
  String $adminserver_address = 'localhost',
  Integer $adminserver_port   = 7001,
  String $user_config_dir     = undef,
  String $weblogic_user       = 'weblogic',
  String $weblogic_password   = undef,
  String $os_user             = $::orawls::weblogic::os_user,
  String $os_group            = $::orawls::weblogic::os_group,
  String $download_dir        = $::orawls::weblogic::download_dir,
  Boolean $log_output         = $::orawls::weblogic::log_output,
)
{
  # the py script used by the wlst*-
  file { "${download_dir}/${title}storeUserConfig.py":
    ensure  => present,
    path    => "${download_dir}/${title}storeUserConfig.py",
    content => epp('orawls/wlst/storeUserConfig.py.epp',
                   { 'weblogic_user' => $weblogic_user,
                     'adminserver_address' => $adminserver_address,
                     'adminserver_port' => $adminserver_port,
                     'domain_name' => $domain_name,
                     'os_user' => $os_user,       
                     'user_config_dir' => $user_config_dir }),
    backup  => false,
    replace => true,
    mode    => '0555',
    owner   => $os_user,
    group   => $os_group,
  }

  $javaCommand = 'java -Dweblogic.management.confirmKeyfileCreation=true -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning '
  $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

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

