#
# utils::rcu define
#
# rcu repository creation utility for 12c
#
# @param version used weblogic software like 1036
# @param jdk_home_dir full path to the java home directory like /usr/java/default
# @param os_user the user name with oracle as default
# @param os_group the group name with dba as default
# @param log_output show all the output of the the exec actions
# @param download_dir the directory for temporary created files by this class
# @param fmw_product product for which to create a RCU reposority for
# @param oracle_fmw_product_home_dir path of the rcu command
# @param rcu_action create or delete a repository
# @param rcu_jdbc_url jdbc url to the RCU database server
# @param rcu_database_url rcu database url
# @param rcu_prefix RCU prefix
# @param rcu_password rcu schema password
# @param rcu_sys_user rcu sys schema username
# @param rcu_sys_password rcu sys username password
#
define orawls::utils::rcu(
  Integer $version                                     = $::orawls::weblogic::version,
  Enum['adf','soa','mft', 'wcs', 'forms'] $fmw_product = 'adf',
  String $oracle_fmw_product_home_dir                  = undef,
  String $jdk_home_dir                                 = $::orawls::weblogic::jdk_home_dir,
  String $os_user                                      = $::orawls::weblogic::os_user,
  String $os_group                                     = $::orawls::weblogic::os_group,
  String $download_dir                                 = $::orawls::weblogic::download_dir,
  Boolean $log_output                                  = $::orawls::weblogic::log_output,
  Enum['create','delete'] $rcu_action                  = 'create',
  String $rcu_jdbc_url                                 = undef,   #jdbc...
  String $rcu_database_url                             = undef,   #192.168.50.5:1521:XE
  String $rcu_prefix                                   = undef,
  String $rcu_password                                 = undef,
  String $rcu_sys_user                                 = 'sys',
  String $rcu_sys_password                             = undef,
  Optional[String] $rcu_temp_tablespace                = undef, #temp
  Optional[String] $rcu_tablespace                     = undef, #soa_infra
){

  # TODO: create and use function sanitize_string (fmw.pp, duplicated code)
  $convert_spaces_to_underscores = regsubst($title,'\s','_','G')
  $sanitised_title = regsubst($convert_spaces_to_underscores,'[^a-zA-Z0-9_-]','','G')

  case $facts['kernel'] {
    'Linux','SunOS': {
      $execPath = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
    }
    default: {
      fail('Unrecognized operating system')
    }
  }

  if $rcu_temp_tablespace == undef {
    $rcu_temp_tablespace_cmd  = ""
  } else {
    $rcu_temp_tablespace_cmd  = "-tempTablespace ${rcu_temp_tablespace}"
  }  
  if $rcu_tablespace == undef {
    $rcu_tablespace_cmd  = ""
  } else {
    $rcu_tablespace_cmd  = "-tablespace ${rcu_tablespace}"
  }  

  if $fmw_product == 'adf' {
    if $version >= 1221 {
      $components = "-component MDS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_APPEND ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_VIEWER ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component OPSS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component WLS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component STB ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd}"
      $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
    }
    else {
      $components = "-component MDS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_APPEND ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_VIEWER ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component OPSS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component WLS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component UCSCC ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd}"
      $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
    }
  }
  elsif $fmw_product == 'soa' {
    if $version >= 1221 {
      $components = "-component MDS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_APPEND ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_VIEWER ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component OPSS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component WLS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component STB ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component UCSUMS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component ESS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component SOAINFRA ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd}"
      $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
    }
    else {
      $components = "-component MDS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_APPEND ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_VIEWER ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component OPSS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component WLS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component UCSCC ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component UCSUMS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component UMS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component ESS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component SOAINFRA ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component MFT ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd}"
      $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
    }
  }
  elsif $fmw_product == 'mft' {
    $components = "-component MDS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_APPEND ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_VIEWER ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component OPSS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component WLS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component UCSCC ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component MFT ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component UCSUMS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component ESS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd}"
    $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
  }
  elsif $fmw_product == 'wcs' {
    $components = "-component STB ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component OPSS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component WCSITES ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component WCSITESVS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_APPEND ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_VIEWER ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd}"
    $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
  }
  elsif $fmw_product == 'forms' {
    $components = "-component STB ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_APPEND ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd} -component IAU_VIEWER ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd}-component OPSS ${rcu_temp_tablespace_cmd} ${rcu_tablespace_cmd}"
    $componentsPasswords = [$rcu_password, $rcu_password, $rcu_password, $rcu_password, $rcu_password]
  }
  else {
    fail('Unrecognized FMW fmw_product')
  }

  file { "${download_dir}/rcu_passwords_${fmw_product}_${rcu_action}_${rcu_prefix}_${sanitised_title}.txt":
    ensure  => present,
    content => template('orawls/utils/rcu_passwords.txt.erb'),
    mode    => lookup('orawls::permissions_secret'),
    owner   => $os_user,
    group   => $os_group,
    backup  => false,
    before  => Wls_rcu["${rcu_prefix}_${sanitised_title}"],
  }

  if !defined(File["${download_dir}/checkrcu.py"]) {
    file { "${download_dir}/checkrcu.py":
      ensure => present,
      source => 'puppet:///modules/orawls/wlst/checkrcu.py',
      mode   => lookup('orawls::permissions'),
      owner  => $os_user,
      group  => $os_group,
      backup => false,
      before => Wls_rcu["${rcu_prefix}_${sanitised_title}"],
    }
  }

  if $rcu_action == 'create' {
    $action = '-createRepository'
  }
  elsif $rcu_action == 'delete' {
    $action = '-dropRepository'
  }
  
  wls_rcu{ "${rcu_prefix}_${sanitised_title}":
    ensure       => $rcu_action,
    statement    => "${oracle_fmw_product_home_dir}/bin/rcu -silent ${action} -databaseType ORACLE -connectString ${rcu_database_url} -dbUser ${rcu_sys_user} -dbRole SYSDBA -schemaPrefix ${rcu_prefix} ${components} -f < ${download_dir}/rcu_passwords_${fmw_product}_${rcu_action}_${rcu_prefix}_${sanitised_title}.txt",
    os_user      => $os_user,
    oracle_home  => $oracle_fmw_product_home_dir,
    sys_user     => $rcu_sys_user,
    sys_password => $rcu_sys_password,
    jdbc_url     => $rcu_jdbc_url,
    jdk_home_dir => $jdk_home_dir,
    check_script => "${download_dir}/checkrcu.py",
  }
}
