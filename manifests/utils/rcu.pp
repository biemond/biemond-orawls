# == Class: orawls::utils::rcu
#    rcu for adf 12.1.2 & 12.1.3
#
define orawls::utils::rcu(
  $fmw_product                 = 'adf', # adf|soa|mft
  $oracle_fmw_product_home_dir = undef,
  $jdk_home_dir                = hiera('wls_jdk_home_dir'),
  $os_user                     = hiera('wls_os_user'),      # oracle
  $os_group                    = hiera('wls_os_group'),     # dba
  $download_dir                = hiera('wls_download_dir'), # /data/install
  $rcu_action                  = 'create',
  $rcu_jdbc_url                = undef,   #jdbc...
  $rcu_database_url            = undef,   #192.168.50.5:1521:XE
  $rcu_prefix                  = undef,
  $rcu_password                = undef,
  $rcu_sys_password            = undef,
  $log_output                  = false, # true|false
){

  case $::kernel {
    'Linux','SunOS': {
      $execPath = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
    }
    default: {
      fail('Unrecognized operating system')
    }
  }

  if $fmw_product == 'adf' {
    $components = '-component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component WLS -component UCSCC  '
    $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password]
  }
  elsif $fmw_product == 'soa' {
    $components = '-component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component WLS -component UCSCC -component UCSUMS -component UMS -component ESS -component SOAINFRA -component MFT '
    $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password]
  }
  elsif $fmw_product == 'mft' {
    $components = '-component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component WLS -component UCSCC -component MFT -component UCSUMS -component ESS'
    $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password,$rcu_password]
  } else {
    fail('Unrecognized FMW fmw_product')
  }

  file { "${download_dir}/rcu_passwords_${fmw_product}_${rcu_action}_${rcu_prefix}.txt":
    ensure  => present,
    content => template('orawls/utils/rcu_passwords.txt.erb'),
    mode    => '0775',
    owner   => $os_user,
    group   => $os_group,
    backup  => false,
    before  => Wls_rcu[$rcu_prefix],
  }

  if !defined(File["${download_dir}/checkrcu.py"]) {
    file { "${download_dir}/checkrcu.py":
      ensure => present,
      source => 'puppet:///modules/orawls/wlst/checkrcu.py',
      mode   => '0775',
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
    statement    => "${oracle_fmw_product_home_dir}/bin/rcu -silent ${action} -databaseType ORACLE -connectString ${rcu_database_url} -dbUser SYS -dbRole SYSDBA -schemaPrefix ${rcu_prefix} ${components} -f < ${download_dir}/rcu_passwords_${fmw_product}_${rcu_action}_${rcu_prefix}.txt",
    os_user      => $os_user,
    oracle_home  => $oracle_fmw_product_home_dir,
    sys_password => $rcu_sys_password,
    jdbc_url     => $rcu_jdbc_url,
    jdk_home_dir => $jdk_home_dir,
    check_script => "${download_dir}/checkrcu.py",
  }
}
