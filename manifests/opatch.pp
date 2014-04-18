# == Define: orawls::opatch
#
# installs oracle patches for Oracle products
#
##
define orawls::opatch (
  $oracle_product_home_dir = undef, # /opt/oracle/middleware11gR1
  $jdk_home_dir            = hiera('wls_jdk_home_dir' , undef), # /usr/java/jdk1.7.0_45
  $patch_id                = undef,
  $patch_file              = undef,
  $os_user                 = hiera('wls_os_user'      , undef), # oracle
  $os_group                = hiera('wls_os_group'     , undef), # dba
  $download_dir            = hiera('wls_download_dir' , undef), # /data/install
  $source                  = hiera('wls_source'       , undef), # puppet:///modules/orawls/ | /mnt | /vagrant
  $remote_file             = true,  # true|false
  $log_output              = false, # true|false
)
{
  $exec_path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

  if $source == undef {
    $mountPoint = "puppet:///modules/orawls/"
  } else {
    $mountPoint = $source
  }

  if $remote_file == true {

    # the patch used by the opatch
    if !defined(File["${download_dir}/${patch_file}"]) {
      file { "${download_dir}/${patch_file}":
        ensure => present,
        source => "${mountPoint}/${patch_file}",
        backup => false,
        mode   => '0775',
        owner  => $os_user,
        group  => $os_group,
      }
    }

    exec { "extract opatch ${patch_file} ${title}":
      command   => "unzip -n ${download_dir}/${patch_file} -d ${download_dir}",
      require   => File["${download_dir}/${patch_file}"],
      creates   => "${download_dir}/${patch_id}",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
    }
  } else {
    exec { "extract opatch ${patch_file} ${title}":
      command   => "unzip -n ${source}/${patch_file} -d ${download_dir}",
      creates   => "${download_dir}/${patch_id}",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
    }
  }

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

  opatch{ $patch_id:
    ensure                  => present,
    os_user                 => $os_user,
    oracle_product_home_dir => $oracle_product_home_dir,
    orainst_dir             => $oraInstPath,
    jdk_home_dir            => $jdk_home_dir,
    extracted_patch_dir     => "${download_dir}/${patch_id}",
    require                 => Exec["extract opatch ${patch_file} ${title}"],
  }

}

