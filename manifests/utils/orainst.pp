# == define: orawls::utils::orainst
#
#  creates oraInst.loc for oracle products
#
#
##
define orawls::utils::orainst
(
  String $ora_inventory_dir = undef,
  String $os_group          = lookup('orawls::group'),
  String $orainstpath_dir   = lookup('orawls::orainst_dir'),
)
{
  if $facts['kernel'] == 'SunOS' {
    if !defined(File[$orainstpath_dir]) {
      file { $orainstpath_dir:
        ensure => directory,
        before => File["${orainstpath_dir}/oraInst.loc"],
        mode   => lookup('orawls::permissions'),
      }
    }
  }

  if !defined(File["${orainstpath_dir}/oraInst.loc"]) {
    file { "${orainstpath_dir}/oraInst.loc":
      ensure  => present,
      content => epp('orawls/utils/oraInst.loc.epp',
                     {'ora_inventory_dir'=> $ora_inventory_dir,
                      'os_group'         => $os_group }),
      mode    => lookup('orawls::permissions'),
    }
  }
}