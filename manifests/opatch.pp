# == Define: orawls::opatch
#
# installs oracle patches for Oracle products
#
##
define orawls::opatch (
  $oracle_product_home_dir = undef, # /opt/oracle/middleware11gR1
  $jdk_home_dir            = hiera('wls_jdk_home_dir' , undef), # /usr/java/jdk1.7.0_45
  $patchId                 = undef,
  $patchFile               = undef,
  $os_user                 = hiera('wls_os_user'      , undef), # oracle
  $os_group                = hiera('wls_os_group'     , undef), # dba
  $download_dir            = hiera('wls_download_dir' , undef), # /data/install
  $source                  = hiera('wls_source'       , undef), # puppet:///modules/orawls/ | /mnt | /vagrant
  $log_output              = false, # true|false
)
{
  $exec_path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

  # check if the opatch already is installed
  $found = opatch_exists($oracle_product_home_dir, $patchId)

  if $found == undef {
    $continue = true
  } else {
    if ($found) {
      $continue = false
    } else {
      notify { "orawls::opatch ${title} ${oracle_product_home_dir} does not exists": }
      $continue = true
    }
  }

  if ($continue) {
    if $source == undef {
      $mountPoint = "puppet:///modules/orawls/"
    } else {
      $mountPoint = $source
    }

    # the patch used by the opatch
    if !defined(File["${download_dir}/${patchFile}"]) {
      file { "${download_dir}/${patchFile}":
         source => "${mountPoint}/${patchFile}",
         ensure => present,
         backup  => false,
         mode   => 0775,
         owner  => $os_user,
         group  => $os_group,
      }
    }

    $oPatchCommand = "opatch apply -silent -jre"

    exec { "extract opatch ${patchFile} ${title}":
      command   => "unzip -n ${download_dir}/${patchFile} -d ${download_dir}",
      require   => File["${download_dir}/${patchFile}"],
      creates   => "${download_dir}/${patchId}",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
    }

    exec { "exec opatch ux ${title}":
      command   => "${oracle_product_home_dir}/OPatch/${oPatchCommand} ${jdk_home_dir}/jre -oh ${oracle_product_home_dir} ${download_dir}/${patchId}",
      require   => Exec["extract opatch ${patchFile} ${title}"],
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
    }

  }
}
