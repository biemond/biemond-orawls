# == Define: orawls::storeuserconfig
#
# generic storeuserconfig wlst script
#
define orawls::storeuserconfig (
  $domain_name                = undef,
  $weblogic_password          = undef,
  $weblogic_home_dir          = $::orawls::weblogic::weblogic_home_dir, # /opt/oracle/middleware11gR1/wlserver_103
  $jdk_home_dir               = $::orawls::weblogic::jdk_home_dir,      # /usr/java/jdk1.7.0_45
  $adminserver_address        = 'localhost',
  $adminserver_port           = 7001,
  $user_config_dir            = undef,                                           #'/home/oracle',
  $weblogic_user              = 'weblogic',
  $os_user                    = $::orawls::weblogic::os_user, # oracle
  $os_group                   = $::orawls::weblogic::os_group, # dba
  $download_dir               = $::orawls::weblogic::download_dir, # /data/install
  $log_output                 = $::orawls::weblogic::log_output,                                           # true|false
)
{
  # Must include domain_name
  unless $domain_name {
    fail('A user config store must be associated with a domain.')
  }

  # Must include weblogic password
  unless $weblogic_password {
    fail('A weblogic password is needed to modify a user config store.')
  }

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
