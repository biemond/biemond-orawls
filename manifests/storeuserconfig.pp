# == Define: orawls::storeuserconfig
#
# generic storeuserconfig wlst script
#
define orawls::storeuserconfig (
  $domain_name                = undef,
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'   , undef),      # /opt/oracle/middleware11gR1/wlserver_103
  $jdk_home_dir               = hiera('wls_jdk_home_dir'        , undef),      # /usr/java/jdk1.7.0_45
  $adminserver_address        = "localhost",
  $adminserver_port           = 7001,
  $user_config_dir            = undef,                                         #'/home/oracle',
  $weblogic_user              = hiera('wls_weblogic_user'       , "weblogic"),
  $weblogic_password          = undef,
  $os_user                    = hiera('wls_os_user'             , undef), # oracle
  $os_group                   = hiera('wls_os_group'            , undef), # dba
  $download_dir               = hiera('wls_download_dir'        , undef), # /data/install
  $log_output                 = false, # true|false
)
{
  # the py script used by the wlst*-
  file { "${download_dir}/${title}storeUserConfig.py":
    path    => "${download_dir}/${title}storeUserConfig.py",
    content => template("orawls/wlst/storeUserConfig.py.erb"),
    ensure  => present,
    backup  => false,
    replace => true,
    mode    => 0555,
    owner   => $os_user,
    group   => $os_group,
  }

  $javaCommand = "java -Dweblogic.management.confirmKeyfileCreation=true -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning "
  $exec_path = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

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

