# == Define: orawls::oud::control
#
# start or stop an Oracle Unified Directory LDAP instance
##
define orawls::oud::control(
  $oud_instances_home_dir = undef,
  $oud_instance_name      = undef,
  $action                 = 'start', # start|stop
  $os_user                = hiera('wls_os_user'), # oracle
  $os_group               = hiera('wls_os_group'), # dba
  $log_output             = false, # true|false
){

  $exec_path   = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  case $::kernel {
    'Linux': {
      $checkCommand = "/bin/ps -ef | grep -v grep | /bin/grep '${oud_instances_home_dir}/${oud_instance_name}/OUD'"
    }
    'SunOS': {
      $checkCommand = "/usr/ucb/ps wwxa | grep -v grep | /bin/grep '${oud_instances_home_dir}/${oud_instance_name}/OUD'"
    }
    default: {
      fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
    }
  }

  if $action == 'start' {
    exec { "start oud ${title}":
      command   => "${oud_instances_home_dir}/${oud_instance_name}/OUD/bin/start-ds",
      unless    => $checkCommand,
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      timeout   => 0,
      logoutput => $log_output,
    }
  } else {
    exec { "stop oud ${title}":
      command   => "${oud_instances_home_dir}/${oud_instance_name}/OUD/bin/stop-ds",
      onlyif    => $checkCommand,
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      timeout   => 0,
      logoutput => $log_output,
    }
  }
}
