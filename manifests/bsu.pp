# == Define: orawls::bsu
#
# installs WebLogic BSU patch
##
define orawls::bsu (
  $ensure                 = 'present',  #present|absent
  $version                = hiera('wls_version', 1036),  # 1036|1111|1211
  $middleware_home_dir    = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $weblogic_home_dir      = hiera('wls_weblogic_home_dir'),
  $jdk_home_dir           = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $patch_id               = undef,
  $patch_file             = undef,
  $os_user                = hiera('wls_os_user'), # oracle
  $os_group               = hiera('wls_os_group'), # dba
  $download_dir           = hiera('wls_download_dir'), # /data/install
  $source                 = hiera('wls_source', undef), # puppet:///modules/orawls/ | /mnt | /vagrant
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

  if $ensure == 'present' {
    # the patch used by the bsu
    if $remote_file == true {
      file { "${download_dir}/${patch_file}":
        ensure   => file,
        source   => "${mountPoint}/${patch_file}",
        require  => File["${middleware_home_dir}/utils/bsu/cache_dir"],
        backup   => false,
        mode     => '0775',
        owner    => $os_user,
        group    => $os_group,
        before   => Exec["extract ${patch_file}"],
      }
      $disk1_file = "${download_dir}/${patch_file}"
    } else {
      $disk1_file = "${source}/${patch_file}"
    }

    exec { "extract ${patch_file}":
      command   => "unzip -n ${disk1_file} -d ${middleware_home_dir}/utils/bsu/cache_dir",
      creates   => "${middleware_home_dir}/utils/bsu/cache_dir/${patch_id}.jar",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => false,
      before    => Bsu_patch[$patch_id],
    }

    if ( $version == 1111 ) {
      $patch_version = 1036
    } else {
      $patch_version = $version
    }

    exec { "patch policy for ${patch_file}":
      command   => "bash -c \"{ echo 'grant codeBase \\\"file:${middleware_home_dir}/patch_wls1036/patch_jars/-\\\" {'; echo '      permission java.security.AllPermission;'; echo '};'; } >> ${middleware_home_dir}/wlserver_10.3/server/lib/weblogic.policy\"",
      unless    => "grep 'file:${middleware_home_dir}/patch_wls1036/patch_jars/-' ${weblogic_home_dir}/server/lib/weblogic.policy",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
      require   => Bsu_patch[$patch_id],
    }
  }

  bsu_patch{ $patch_id:
    ensure              => $ensure,
    os_user             => $os_user,
    middleware_home_dir => $middleware_home_dir,
    weblogic_home_dir   => $weblogic_home_dir,
    jdk_home_dir        => $jdk_home_dir,
  }

}
