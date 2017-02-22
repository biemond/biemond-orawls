#
# utils::orainst define
#
# creates oraInst.loc for oracle products
#
# @param ora_inventory_dir define your own location of the Oracle inventory
# @param orainstpath_dir the location of orainst.loc, default it will the default directory for Linux or Solaris
# @param os_group the group name with dba as default
#
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
        mode   => lookup('orawls::permissions_restricted'),
      }
    }
  }

  if !defined(File["${orainstpath_dir}/oraInst.loc"]) {
    file { "${orainstpath_dir}/oraInst.loc":
      ensure  => present,
      content => epp('orawls/utils/oraInst.loc.epp', {
                      'ora_inventory_dir' => $ora_inventory_dir,
                      'os_group'          => $os_group }),
      mode    => lookup('orawls::permissions_restricted'),
    }
  }
}