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

  # check if the opatch already is installed
  $found = opatch_exists($oracle_product_home_dir, $patch_id)

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

    $oPatchCommand = "opatch apply -silent -jre"

    exec { "exec opatch ux ${title}":
      command   => "${oracle_product_home_dir}/OPatch/${oPatchCommand} ${jdk_home_dir}/jre -oh ${oracle_product_home_dir} ${download_dir}/${patch_id}",
      require   => Exec["extract opatch ${patch_file} ${title}"],
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
    }

  }
}
