# == Define: orawls::control
#
# Weblogic Server control, starts or stops a managed server
#
#  action        = start|stop
#  wlsServerType = admin|managed
#  wlsTarget     = Server|Cluster
#
define orawls::control (
  $weblogic_home_dir          = undef,
  $jdk_home_dir               = undef, # /usr/java/jdk1.7.0_45
  $domain_name                = undef,
  $domain_dir                 = undef,
  $server_type                = 'admin',  # admin|managed
  $target                     = 'Server', # Server|Cluster
  $server                     = 'AdminServer',
  $adminserver_address        = 'localhost',
  $adminserver_port           = 7001,
  $nodemanager_port           = 5556,
  $action                     = 'start', # start|stop
  $weblogic_user              = "weblogic",
  $weblogic_password          = undef,
  $os_user                    = undef, # oracle
  $os_group                   = undef, # dba
  $log_dir                    = undef, # /data/logs
  $download_dir               = undef, # /data/install
  $log_output                 = false, # true|false
)
{

  $javaCommand = "java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning "

  $exec_path    = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"
  $JAVA_HOME    = $jdk_home_dir
  $checkCommand = "/bin/ps -ef | grep -v grep | /bin/grep 'weblogic.Name=${server}' | /bin/grep ${domain_name}"

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
    path    => "${download_dir}/${title}${script}",
    content => template("orawls/wlst/${script}.erb"),
    ensure  => present,
    replace => true,
    mode    => 0775,
    owner   => $os_user,
    group   => $os_group,
  }

  if $action == 'start' {
    exec { "execwlst ${title}${script} ":
      command     => "${javaCommand} ${download_dir}/${title}${script} ${weblogic_password}",
      environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar", "JAVA_HOME=${JAVA_HOME}"],
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
      environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar", "JAVA_HOME=${JAVA_HOME}"],
      onlyif      => $checkCommand,
      require     => File["${download_dir}/${title}${script}"],
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      timeout     => 0,
    }
  }

}
