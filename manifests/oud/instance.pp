# == Define: orawls::oud::instance
#
# create an Oracle Unified Directory LDAP instance
##
define orawls::oud::instance (
  Integer $version                                        = $::orawls::weblogic::version,
  String $oracle_base_home_dir                            = $::orawls::weblogic::oracle_base_home_dir,
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir,
  String $oud_home                                        = undef,
  String $oud_instance_name                               = undef,
  String $oud_root_user_password                          = undef,
  String $oud_base_dn                                     = 'dc=example,dc=com',
  Integer $oud_ldap_port                                  = 1389,
  Integer $oud_admin_connector_port                       = 4444,
  Integer $oud_ldaps_port                                 = 1636,
  String $os_user                                         = $::orawls::weblogic::os_user,
  String $os_group                                        = $::orawls::weblogic::os_group,
  String $download_dir                                    = $::orawls::weblogic::download_dir,
  Boolean $log_output                                     = $::orawls::weblogic::log_output,
){

  $instances_home = "${oracle_base_home_dir}/oud_instances"

  if !defined(File[$instances_home]) {
    file { $instances_home:
      ensure  => directory,
      recurse => false,
      replace => false,
      mode    => lookup('orawls::permissions'),
      owner   => $os_user,
      group   => $os_group,
    }
  }

  $exec_path = lookup('orawls::exec_path')

  exec { "rootUserPasswordFile ${title}":
    command   => "echo ${oud_root_user_password} > ${instances_home}/${oud_instance_name}pass.txt",
    timeout   => 0,
    unless    => "test -d ${instances_home}/${oud_instance_name}",
    require   => File[$instances_home],
    path      => $exec_path,
    user      => $os_user,
    group     => $os_group,
    logoutput => true,
  }

  exec { "create ldap ${title}":
    command     => "${oud_home}/oud-setup --cli --baseDN ${oud_base_dn} --addBaseEntry --netsvc --ldapPort ${oud_ldap_port} --adminConnectorPort ${oud_admin_connector_port} --skipPortCheck --rootUserDN cn=Directory\\ Manager --rootUserPasswordFile ${instances_home}/${oud_instance_name}pass.txt --doNotStart --serverTuning autotune --importTuning autotune --enableStartTLS --ldapsPort ${oud_ldaps_port} --generateSelfSignedCertificate --hostName ${facts['fqdn']} --no-prompt --noPropertiesFile",
    timeout     => 0,
    environment => ["INSTANCE_NAME=../oud_instances/${oud_instance_name}"],
    unless      => "test -d ${instances_home}/${oud_instance_name}",
    require     => [File[$instances_home],Exec["rootUserPasswordFile ${title}"],],
    path        => $exec_path,
    user        => $os_user,
    group       => $os_group,
    logoutput   => true,
  }

  exec { "absent rootUserPasswordFile ${title}":
    command   => "rm ${instances_home}/${oud_instance_name}pass.txt",
    timeout   => 0,
    onlyif    => "test -f ${instances_home}/${oud_instance_name}pass.txt",
    require   => [Exec["create ldap ${title}"],Exec["rootUserPasswordFile ${title}"],],
    path      => $exec_path,
    user      => $os_user,
    group     => $os_group,
    logoutput => true,
  }
}