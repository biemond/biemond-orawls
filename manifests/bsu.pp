# == Define: orawls::bsu
#
# installs WebLogic BSU patch
##
define orawls::bsu (
  $middleware_home_dir    = hiera('wls_middleware_home_dir' , undef), # /opt/oracle/middleware11gR1
  $weblogic_home_dir      = hiera('wls_weblogic_home_dir'   , undef),
  $jdk_home_dir           = hiera('wls_jdk_home_dir'        , undef), # /usr/java/jdk1.7.0_45
  $patch_id               = undef,
  $patch_file             = undef,
  $os_user                = hiera('wls_os_user'             , undef), # oracle
  $os_group               = hiera('wls_os_group'            , undef), # dba
  $download_dir           = hiera('wls_download_dir'        , undef), # /data/install
  $source                 = hiera('wls_source'              , undef), # puppet:///modules/orawls/ | /mnt | /vagrant
  $remote_file            = true,  # true|false
  $log_output             = false, # true|false
)
{
  $exec_path = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:${jdk_home_dir}/bin"

  if $source == undef {
    $mountPoint = 'puppet:///modules/orawls/'
  }
  else {
    $mountPoint = $source
  }

  if !defined(File["${middleware_home_dir}/utils/bsu/cache_dir"]) {
    file { "${middleware_home_dir}/utils/bsu/cache_dir":
      ensure  => directory,
      recurse => false,
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
    }
  }

  # the patch used by the bsu
  if $remote_file == true {
    if !defined(File["${download_dir}/${patch_file}"]) {
      file { "${download_dir}/${patch_file}":
        ensure  => present,
        source  => "${mountPoint}/${patch_file}",
        require => File["${middleware_home_dir}/utils/bsu/cache_dir"],
        backup  => false,
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
      }
    }
    exec { "extract ${patch_file}":
      command   => "unzip -n ${download_dir}/${patch_file} -d ${middleware_home_dir}/utils/bsu/cache_dir",
      require   => File["${download_dir}/${patch_file}"],
      creates   => "${middleware_home_dir}/utils/bsu/cache_dir/${patch_id}.jar",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
    }
  } else {
    exec { "extract ${patch_file}":
      command   => "unzip -n ${source}/${patch_file} -d ${middleware_home_dir}/utils/bsu/cache_dir",
      creates   => "${middleware_home_dir}/utils/bsu/cache_dir/${patch_id}.jar",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
    }
  }

  bsu_patch{ $patch_id:
    ensure              => present,
    os_user             => $os_user,
    middleware_home_dir => $middleware_home_dir,
    weblogic_home_dir   => $weblogic_home_dir,
    jdk_home_dir        => $jdk_home_dir,
    require             => Exec["extract ${patch_file}"],
  }

}
