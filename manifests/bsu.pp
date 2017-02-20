#
# bsu define
#
# installs WebLogic 11g BSU patch
#
# @param middleware_home_dir directory of the Oracle software inside the oracle base directory, will be default derived from the weblogic class
# @param weblogic_home_dir directory of the WebLogic software inside the middleware directory, will be default derived from the weblogic class
# @param jdk_home_dir full path to the java home directory like /usr/java/default, will be default derived from the weblogic class
# @param os_user the user name with oracle as default, will be default derived from the weblogic class
# @param os_group the group name with dba as default, will be default derived from the weblogic class
# @param log_output show all the output of the the exec actions, will be default derived from the weblogic class
# @param download_dir the directory for temporary created files by this class, will be default derived from the weblogic class
#
define orawls::bsu (
  Enum['present','absent'] $ensure  = 'present',
  Integer $version                  = $::orawls::weblogic::version,
  String $weblogic_home_dir         = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir       = $::orawls::weblogic::middleware_home_dir,
  String $jdk_home_dir              = $::orawls::weblogic::jdk_home_dir,
  String $patch_id                  = undef,
  String $patch_file                = undef,
  String $os_user                   = $::orawls::weblogic::os_user,
  String $os_group                  = $::orawls::weblogic::os_group,
  String $download_dir              = $::orawls::weblogic::download_dir,
  String $puppet_download_mnt_point = $::orawls::weblogic::puppet_download_mnt_point,
  Boolean $remote_file              = $::orawls::weblogic::remote_file,
  Boolean $log_output               = $::orawls::weblogic::log_output,
)
{
  $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

  if !defined(File["${middleware_home_dir}/utils/bsu/cache_dir"]) {
    file { "${middleware_home_dir}/utils/bsu/cache_dir":
      ensure  => directory,
      recurse => false,
      mode    => lookup('orawls::permissions'),
      owner   => $os_user,
      group   => $os_group,
    }
  }

  if $ensure == 'present' {
    # the patch used by the bsu
    if $remote_file == true {
      file { "${download_dir}/${patch_file}":
        ensure  => file,
        source  => "${puppet_download_mnt_point}/${patch_file}",
        require => File["${middleware_home_dir}/utils/bsu/cache_dir"],
        backup  => false,
        mode    => lookup('orawls::permissions'),
        owner   => $os_user,
        group   => $os_group,
        before  => Exec["extract ${patch_file}"],
      }
      $disk1_file = "${download_dir}/${patch_file}"
    } else {
      $disk1_file = "${puppet_download_mnt_point}/${patch_file}"
    }

    exec { "extract ${patch_file}":
      command   => "unzip -o ${disk1_file} -d ${middleware_home_dir}/utils/bsu/cache_dir",
      creates   => "${middleware_home_dir}/utils/bsu/cache_dir/${patch_id}.jar",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => false,
      before    => Bsu_patch["${middleware_home_dir}:${patch_id}"],
    }

    if ( $version == 1111 ) {
      $patch_version = 1036
    } else {
      $patch_version = $version
    }

    exec { "change memory params for ${patch_file}":
      command   => "sed -e's/MEM_ARGS=\"-Xms256m -Xmx512m\"/MEM_ARGS=\"-Xms256m -Xmx1024m -XX:-UseGCOverheadLimit\"/g' ${middleware_home_dir}/utils/bsu/bsu.sh > ${download_dir}/bsu.sh && mv ${download_dir}/bsu.sh ${middleware_home_dir}/utils/bsu/bsu.sh;chmod +x ${middleware_home_dir}/utils/bsu/bsu.sh",
      unless    => "grep 'MEM_ARGS=\"-Xms256m -Xmx1024m -XX:-UseGCOverheadLimit\"' ${middleware_home_dir}/utils/bsu/bsu.sh",
      before    => Bsu_patch["${middleware_home_dir}:${patch_id}"],
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      cwd       => $download_dir,
      logoutput => $log_output,
    }

    exec { "patch policy for ${patch_file}":
      command   => "bash -c \"{ echo 'grant codeBase \\\"file:${middleware_home_dir}/patch_wls1036/patch_jars/-\\\" {'; echo '      permission java.security.AllPermission;'; echo '};'; } >> ${weblogic_home_dir}/server/lib/weblogic.policy\"",
      unless    => "grep 'file:${middleware_home_dir}/patch_wls1036/patch_jars/-' ${weblogic_home_dir}/server/lib/weblogic.policy",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
      require   => Bsu_patch["${middleware_home_dir}:${patch_id}"],
    }
  }

  bsu_patch{ "${middleware_home_dir}:${patch_id}":
    ensure              => $ensure,
    os_user             => $os_user,
    middleware_home_dir => $middleware_home_dir,
    weblogic_home_dir   => $weblogic_home_dir,
    jdk_home_dir        => $jdk_home_dir,
  }

}
