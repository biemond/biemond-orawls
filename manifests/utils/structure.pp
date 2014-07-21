# == define: orawls::utils::structure
#
#  create directories for the download folder and oracle base home
#
#
##
define orawls::utils::structure (
  $oracle_base_home_dir = undef,
  $ora_inventory_dir    = undef,
  $wls_domains_dir      = undef,
  $wls_apps_dir         = undef,
  $os_user              = undef,
  $os_group             = undef,
  $download_dir         = undef,
  $log_output           = false,) {

  $exec_path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

  Exec {
    logoutput => $log_output,
  }

  # create all folders
  if !defined(Exec["create ${oracle_base_home_dir} directory"]) {
    exec { "create ${oracle_base_home_dir} directory":
      command => "mkdir -p ${oracle_base_home_dir}",
      unless  => "test -d ${oracle_base_home_dir}",
      user    => 'root',
      path    => $exec_path,
    }
  }

  if !defined(Exec["create ${download_dir} home directory"]) {
    exec { "create ${download_dir} home directory":
      command => "mkdir -p ${download_dir}",
      unless  => "test -d ${download_dir}",
      user    => 'root',
      path    => $exec_path,
    }
  }

  if $wls_domains_dir != undef {
    if !defined(Exec["create ${wls_domains_dir} directory"]) {
      exec { "create ${wls_domains_dir} directory":
        command => "mkdir -p ${wls_domains_dir}",
        unless  => "test -d ${wls_domains_dir}",
        user    => 'root',
        path    => $exec_path,
      }
    }
  }

  if $wls_apps_dir != undef {
    if !defined(Exec["create ${wls_apps_dir} directory"]) {
      exec { "create ${wls_apps_dir} directory":
        command => "mkdir -p ${wls_apps_dir}",
        unless  => "test -d ${wls_apps_dir}",
        user    => 'root',
        path    => $exec_path,
      }
    }
  }

  # also set permissions on downloadDir
  if !defined(File[$download_dir]) {
    # check oracle install folder
    file { $download_dir:
      ensure  => directory,
      recurse => false,
      replace => false,
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
      require => Exec["create ${download_dir} home directory"],
    }
  }

  # also set permissions on oracleHome
  if !defined(File[$oracle_base_home_dir]) {
    file { $oracle_base_home_dir:
      ensure  => directory,
      recurse => false,
      replace => false,
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
      require => Exec["create ${oracle_base_home_dir} directory"],
    }
  }

  # also set permissions on oraInventory
  if !defined(File[$ora_inventory_dir]) {
    file { $ora_inventory_dir:
      ensure  => directory,
      recurse => false,
      replace => false,
      mode    => '0770',
      owner   => $os_user,
      group   => $os_group,
      require => [Exec["create ${oracle_base_home_dir} directory"],File[$oracle_base_home_dir]],
    }
  }

  # also set permissions on domains_dir
  if $wls_domains_dir != undef {
    if !defined(File[$wls_domains_dir]) {
      file { $wls_domains_dir:
        ensure  => directory,
        recurse => false,
        replace => false,
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
        require => Exec["create ${wls_domains_dir} directory"],
      }
    }
  }
  if $wls_apps_dir != undef {
    # also set permissions on apps_dir
    if !defined(File[$wls_apps_dir]) {
      file { $wls_apps_dir:
        ensure  => directory,
        recurse => false,
        replace => false,
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
        require => Exec["create ${wls_apps_dir} directory"],
      }
    }
  }
}