#
# utils::rcu define
#
# rcu repository creation utility for 12c
#
# @param jdk_home_dir full path to the java home directory like /usr/java/default, will be default derived from the weblogic class
# @param os_user the user name with oracle as default, will be default derived from the weblogic class
# @param os_group the group name with dba as default, will be default derived from the weblogic class
# @param log_output show all the output of the the exec actions, will be default derived from the weblogic class
# @param download_dir the directory for temporary created files by this class, will be default derived from the weblogic class
#
define orawls::utils::rcu(
  Integer $version                       = $::orawls::weblogic::version,
  Enum['adf','soa','mft'] $fmw_product   = 'adf',
  String $oracle_fmw_product_home_dir    = undef,
  String $jdk_home_dir                   = $::orawls::weblogic::jdk_home_dir,
  String $os_user                        = $::orawls::weblogic::os_user,
  String $os_group                       = $::orawls::weblogic::os_group,
  String $download_dir                   = $::orawls::weblogic::download_dir,
  Boolean $log_output                    = $::orawls::weblogic::log_output,
  Enum['create','delete'] $rcu_action    = 'create',
  String $rcu_jdbc_url                   = undef,   #jdbc...
  String $rcu_database_url               = undef,   #192.168.50.5:1521:XE
  String $rcu_prefix                     = undef,
  String $rcu_password                   = undef,
  String $rcu_sys_user                   = 'sys',
  String $rcu_sys_password               = undef,
){

  case $facts['kernel'] {
    'Linux','SunOS': {
      $execPath = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
    }
    default: {
      fail('Unrecognized operating system')
    }
  }

  if $fmw_product == 'adf' {
    if $version >= 1221 {
      $components = '-component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component WLS -component STB '
      $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
    }
    else {
      $components = '-component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component WLS -component UCSCC '
      $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
    }
  }
  elsif $fmw_product == 'soa' {
    if $version >= 1221 {
      $components = '-component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component WLS -component STB -component UCSUMS -component ESS -component SOAINFRA '
      $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
    }
    else {
      $components = '-component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component WLS -component UCSCC -component UCSUMS -component UMS -component ESS -component SOAINFRA -component MFT '
      $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
    }
  }
  elsif $fmw_product == 'mft' {
    $components = '-component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component WLS -component UCSCC -component MFT -component UCSUMS -component ESS'
    $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
  } else {
    fail('Unrecognized FMW fmw_product')
  }

  file { "${download_dir}/rcu_passwords_${fmw_product}_${rcu_action}_${rcu_prefix}.txt":
    ensure  => present,
    content => template('orawls/utils/rcu_passwords.txt.erb'),
    mode    => lookup('orawls::permissions_secret'),
    owner   => $os_user,
    group   => $os_group,
    backup  => false,
    before  => Wls_rcu[$rcu_prefix],
  }

  if !defined(File["${download_dir}/checkrcu.py"]) {
    file { "${download_dir}/checkrcu.py":
      ensure => present,
      source => 'puppet:///modules/orawls/wlst/checkrcu.py',
      mode   => lookup('orawls::permissions'),
      owner  => $os_user,
      group  => $os_group,
      backup => false,
      before => Wls_rcu[$rcu_prefix],
    }
  }

  if $rcu_action == 'create' {
    $action = '-createRepository'
  }
  elsif $rcu_action == 'delete' {
    $action = '-dropRepository'
  }

  wls_rcu{ $rcu_prefix:
    ensure       => $rcu_action,
    statement    => "${oracle_fmw_product_home_dir}/bin/rcu -silent ${action} -databaseType ORACLE -connectString ${rcu_database_url} -dbUser ${rcu_sys_user} -dbRole SYSDBA -schemaPrefix ${rcu_prefix} ${components} -f < ${download_dir}/rcu_passwords_${fmw_product}_${rcu_action}_${rcu_prefix}.txt",
    os_user      => $os_user,
    oracle_home  => $oracle_fmw_product_home_dir,
    sys_user     => $rcu_sys_user,
    sys_password => $rcu_sys_password,
    jdbc_url     => $rcu_jdbc_url,
    jdk_home_dir => $jdk_home_dir,
    check_script => "${download_dir}/checkrcu.py",
  }
}
