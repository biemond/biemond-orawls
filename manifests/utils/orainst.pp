# == define: orawls::utils::orainst
#
#  creates oraInst.loc for oracle products
#
#
##
define orawls::utils::orainst
(
  $ora_inventory_dir = undef,
  $os_group          = $::orawls::weblogic::os_group,
)
{
  case $::kernel {
    'Linux': {
      $oraInstPath        = '/etc'
    }
    'SunOS': {
      $oraInstPath        = '/var/opt/oracle'
      if !defined(File[$oraInstPath]) {
        file { $oraInstPath:
          ensure => directory,
          before => File["${oraInstPath}/oraInst.loc"],
          mode   => '0755',
        }
      }
    }
    default: {
        fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
    }
  }

  if !defined(File["${oraInstPath}/oraInst.loc"]) {
    file { "${oraInstPath}/oraInst.loc":
      ensure  => present,
      content => template('orawls/utils/oraInst.loc.erb'),
      mode    => '0755',
    }
  }
}
