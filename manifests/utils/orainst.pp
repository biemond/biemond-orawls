# == define: orawls::utils::orainst
#
#  creates oraInst.loc for oracle products
#
#
##
define orawls::utils::orainst
(
  $ora_inventory_dir = undef,
  $os_group          = undef,
)
{
  case $::kernel {
    'Linux': {
      $oraInstPath        = "/etc"
    }
    'SunOS': {
      $oraInstPath        = "/var/opt"
    }
    default: {
        fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
    }
  }

  if !defined(File["${oraInstPath}/oraInst.loc"]) {
    file { "${oraInstPath}/oraInst.loc":
      ensure  => present,
      content => template("orawls/utils/oraInst.loc.erb"),
    }
  }
}
