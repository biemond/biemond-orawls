# == Define: orawls::control
#
# Weblogic Server control, starts or stops a managed server
#
#  action        = start|stop
#  wlsServerType = admin|managed
#  wlsTarget     = Server|Cluster
#
define orawls::control (
  $middleware_home_dir        = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'),
  $jdk_home_dir               = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $wls_domains_dir            = hiera('wls_domains_dir', undef),
  $domain_name                = hiera('domain_name'),
  $server_type                = 'admin',  # admin|managed
  $target                     = 'Server', # Server|Cluster
  $server                     = 'AdminServer',
  $adminserver_address        = hiera('domain_adminserver_address'    , "localhost"),
  $adminserver_port           = hiera('domain_adminserver_port'       , 7001),
  $nodemanager_port           = hiera('domain_nodemanager_port'       , 5556),
  $action                     = 'start', # start|stop
  $weblogic_user              = hiera('wls_weblogic_user'             , "weblogic"),
  $weblogic_password          = hiera('domain_wls_password'),
  $jsse_enabled               = hiera('wls_jsse_enabled'              , false),
  $custom_trust               = hiera('wls_custom_trust'              , false),
  $trust_keystore_file        = hiera('wls_trust_keystore_file'       , undef),
  $trust_keystore_passphrase  = hiera('wls_trust_keystore_passphrase' , undef),
  $os_user                    = hiera('wls_os_user'), # oracle
  $os_group                   = hiera('wls_os_group'), # dba
  $download_dir               = hiera('wls_download_dir'), # /data/install
  $log_output                 = false, # true|false
)
{
  if ( $wls_domains_dir == undef ) {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir 
  }

  $domain_dir = "${domains_dir}/${domain_name}"
  
  case $::kernel {
    'Linux': {
      $checkCommand   = "/bin/ps -ef | grep -v grep | /bin/grep 'weblogic.Name=${server}' | /bin/grep ${domain_name}"
      $nativeLib      = "linux/x86_64"
      $java_statement = "java"
    }
    'SunOS': {
      $checkCommand   = "/usr/ucb/ps wwxa | grep -v grep | /bin/grep 'weblogic.Name=${server}' | /bin/grep ${domain_name}"
      $nativeLib      = "solaris/x64"
      $java_statement = "java -d64"
    }
    default: {
      fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
    }    
  }

  if ( $custom_trust == true ) {
    $trust_env = "-Dweblogic.security.TrustKeyStore=CustomTrust -Dweblogic.security.CustomTrustKeyStoreFileName=${trust_keystore_file} -Dweblogic.security.CustomTrustKeystorePassPhrase=${trust_keystore_passphrase}"
  } else {
    $trust_env = ""
  }

  if $jsse_enabled == true {
    $javaCommand = "${java_statement} ${trust_env} -Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning "
  } else {
    $javaCommand = "${java_statement} ${trust_env} -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning "
  }

  $exec_path   = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

  Exec {
    logoutput => $log_output,
  }

  if $server_type == 'admin' {
    if $action == 'start' {
      $script = 'startWlsServer2.py'
    } elsif $action == 'stop' {
      $script = 'stopWlsServer2.py'
    } else {
      fail("Unknow action")
    }
  } else {
    if $action == 'start' {
      $script = 'startWlsManagedServer2.py'
    } elsif $action == 'stop' {
      $script = 'stopWlsManagedServer2.py'
    } else {
      fail("Unknow action")
    }
  }

  # the py script used by the wlst
  file { "${download_dir}/${title}${script}":
    ensure  => present,
    path    => "${download_dir}/${title}${script}",
    content => template("orawls/wlst/${script}.erb"),
    backup  => false,
    replace => true,
    mode    => '0775',
    owner   => $os_user,
    group   => $os_group,
  }

  if $action == 'start' {
    exec { "execwlst ${title}${script} ":
      command     => "${javaCommand} ${download_dir}/${title}${script} ${weblogic_password}",
      environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar", 
                      "JAVA_HOME=${jdk_home_dir}"],
      unless      => $checkCommand,
      require     => File["${download_dir}/${title}${script}"],
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      timeout     => 0,
    }
  } elsif $action == 'stop' {
    exec { "execwlst ${title}${script} ":
      command     => "${javaCommand} ${download_dir}/${title}${script} ${weblogic_password}",
      environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                      "JAVA_HOME=${jdk_home_dir}"],
      onlyif      => $checkCommand,
      require     => File["${download_dir}/${title}${script}"],
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      timeout     => 0,
    }
  }

}
