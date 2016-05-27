# == Define: orawls::oud::instance
#
# create an Oracle Unified Directory LDAP instance
##
define orawls::oud::instance (
  $version                    = $::orawls::weblogic::version,
  $oracle_base_home_dir       = $::orawls::weblogic::oracle_base_home_dir , # /opt/oracle
  $middleware_home_dir        = $::orawls::weblogic::middleware_home_dir, # /opt/oracle/middleware11gR1
  $oud_home                   = undef,
  $oud_instance_name          = undef,
  $oud_root_user_password     = undef,
  $oud_baseDN                 = 'dc=example,dc=com',
  $oud_ldapPort               = 1389,
  $oud_adminConnectorPort     = 4444,
  $oud_ldapsPort              = 1636,
  $os_user                    = $::orawls::weblogic::os_user, # oracle
  $os_group                   = $::orawls::weblogic::os_group, # dba
  $download_dir               = $::orawls::weblogic::download_dir, # /data/install
  $log_output                 = $::orawls::weblogic::log_output, # true|false
){

  $instances_home = "${oracle_base_home_dir}/oud_instances"

  if !defined(File[$instances_home]) {
    file { $instances_home:
      ensure  => directory,
      recurse => false,
      replace => false,
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
    }
  }

  $execPath = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

  exec { "rootUserPasswordFile ${title}":
    command   => "echo ${oud_root_user_password} > ${instances_home}/${oud_instance_name}pass.txt",
    timeout   => 0,
    unless    => "test -d ${instances_home}/${oud_instance_name}",
    require   => File[$instances_home],
    path      => $execPath,
    user      => $os_user,
    group     => $os_group,
    logoutput => true,
  }

  exec { "create ldap ${title}":
    command     => "${oud_home}/oud-setup --cli --baseDN ${oud_baseDN} --addBaseEntry --netsvc --ldapPort ${oud_ldapPort} --adminConnectorPort ${oud_adminConnectorPort} --skipPortCheck --rootUserDN cn=Directory\\ Manager --rootUserPasswordFile ${instances_home}/${oud_instance_name}pass.txt --doNotStart --serverTuning autotune --importTuning autotune --enableStartTLS --ldapsPort ${oud_ldapsPort} --generateSelfSignedCertificate --hostName ${::fqdn} --no-prompt --noPropertiesFile",
    timeout     => 0,
    environment => ["INSTANCE_NAME=../oud_instances/${oud_instance_name}"],
    unless      => "test -d ${instances_home}/${oud_instance_name}",
    require     => [File[$instances_home],Exec["rootUserPasswordFile ${title}"],],
    path        => $execPath,
    user        => $os_user,
    group       => $os_group,
    logoutput   => true,
  }

  exec { "absent rootUserPasswordFile ${title}":
    command   => "rm ${instances_home}/${oud_instance_name}pass.txt",
    timeout   => 0,
    onlyif    => "test -f ${instances_home}/${oud_instance_name}pass.txt",
    require   => [Exec["create ldap ${title}"],Exec["rootUserPasswordFile ${title}"],],
    path      => $execPath,
    user      => $os_user,
    group     => $os_group,
    logoutput => true,
  }
}
