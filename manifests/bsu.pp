# == Define: orawls::bsu
#
# installs WebLogic BSU patch
##
define orawls::bsu (
  $middleware_home_dir    = hiera('wls_middleware_home_dir' , undef), # /opt/oracle/middleware11gR1
  $weblogic_home_dir      = hiera('wls_weblogic_home_dir'   , undef),
  $jdk_home_dir           = hiera('wls_jdk_home_dir'        , undef), # /usr/java/jdk1.7.0_45
  $patchId                = undef,
  $patchFile              = undef,
  $os_user                = hiera('wls_os_user'             , undef), # oracle
  $os_group               = hiera('wls_os_group'            , undef), # dba
  $download_dir           = hiera('wls_download_dir'        , undef), # /data/install
  $source                 = hiera('wls_source'              , undef), # puppet:///modules/orawls/ | /mnt | /vagrant
  $log_output             = false, # true|false
)
{
  $exec_path = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:${jdk_home_dir}/bin"

  # check if the bsu already is installed
  $found = bsu_exists($middleware_home_dir, $patchId)

  if $found == undef {
    $continue = true
  } else {
    if ($found) {
      $continue = false
    }
    else {
      notify { "orawls::bsu ${title} ${middleware_home_dir} does not exists": }
      $continue = true
    }
  }

  if ($continue) {
    if $source == undef {
      $mountPoint = "puppet:///modules/orawls/"
    }
    else {
      $mountPoint = $source
    }

    if !defined(File["${middleware_home_dir}/utils/bsu/cache_dir"]) {
      file { "${middleware_home_dir}/utils/bsu/cache_dir":
        ensure  => directory,
        recurse => false,
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
      }
    }

    # the patch used by the bsu
    if !defined(File["${download_dir}/${patchFile}"]) {
      file { "${download_dir}/${patchFile}":
        source  => "${mountPoint}/${patchFile}",
        require => File["${middleware_home_dir}/utils/bsu/cache_dir"],
        backup  => false,
        ensure  => present,
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
      }
    }

    $bsuCommand = "-install -patchlist=${patchId} -prod_dir=${weblogic_home_dir} -verbose"

    exec { "extract ${patchFile}":
      command   => "unzip -n ${download_dir}/${patchFile} -d ${middleware_home_dir}/utils/bsu/cache_dir",
      require   => File["${download_dir}/${patchFile}"],
      creates   => "${middleware_home_dir}/utils/bsu/cache_dir/${patchId}.jar",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
    }

    exec { "exec bsu ux ${title}":
      command     => "${middleware_home_dir}/utils/bsu/bsu.sh ${bsuCommand}",
      require     => Exec["extract ${patchFile}"],
      cwd         => "${middleware_home_dir}/utils/bsu",
      environment => ["USER=${os_user}", "HOME=/home/${os_user}", "LOGNAME=${os_user}"],
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      logoutput   => $log_output,
    }
  }
}
