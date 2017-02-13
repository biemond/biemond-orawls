# == Define: orawls::oud::control
#
# start or stop an Oracle Unified Directory LDAP instance
##
define orawls::oud::control(
  String $oud_instances_home_dir               = undef,
  String $oud_instance_name                    = undef,
  Enum['start','stop'] $action                 = 'start',
  String $os_user                              = $::orawls::weblogic::os_user,
  String $os_group                             = $::orawls::weblogic::os_group,
  Boolean $log_output                          = $::orawls::weblogic::log_output,
){

  $exec_path = lookup('orawls::exec_path')

  case $facts['kernel'] {
    'Linux': {
      $checkCommand = "/bin/ps -ef | grep -v grep | /bin/grep '${oud_instances_home_dir}/${oud_instance_name}/OUD'"
    }
    'SunOS': {
      case $facts['kernelrelease'] {
        '5.11': {
          $checkCommand = "/bin/ps wwxa | /bin/grep -v grep | /bin/grep '${oud_instances_home_dir}/${oud_instance_name}/OUD'"
        }
        default: {
          $checkCommand = "/usr/ucb/ps wwxa | /bin/grep -v grep | /bin/grep '${oud_instances_home_dir}/${oud_instance_name}/OUD'"
        }
      }
    }
    default: {
      fail("Unrecognized operating system ${::kernel}, please use it on a Linux or Solaris host")
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
