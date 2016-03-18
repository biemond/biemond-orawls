# == Define: orawls::opatch
#
# installs oracle patches for Oracle products
#
#
define orawls::opatch(
  $ensure                  = 'present',  #present|absent
  $oracle_product_home_dir = undef, # /opt/oracle/middleware11gR1
  $patch_id                = undef,
  $patch_file              = undef,
  $remote_file             = true,  # true|false
)
{
  $middleware_home_dir  = $::orawls::weblogic::middleware_home_dir
  $weblogic_home_dir    = $::orawls::weblogic::weblogic_home_dir
  $wls_domains_dir      = $::orawls::weblogic::wls_domains_dir
  $wls_apps_dir         = $::orawls::weblogic::wls_apps_dir
  $jdk_home_dir         = $::orawls::weblogic::jdk_home_dir
  $os_user              = $::orawls::weblogic::os_user
  $os_group             = $::orawls::weblogic::os_group
  $download_dir         = $::orawls::weblogic::download_dir
  $log_output           = $::orawls::weblogic::log_output
  $oracle_base_home_dir = $::orawls::weblogic::oracle_base_home_dir
  $source               = $::orawls::weblogic::source
  $temp_directory       = $::orawls::weblogic::temp_directory

  # $exec_path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

  if $source == undef {
    $mountPoint = 'puppet:///modules/orawls/'
  } else {
    $mountPoint = $source
  }

  if $ensure == 'present' {
    if $remote_file == true {
      if ! defined(File["${download_dir}/${patch_file}"]) {
        file { "${download_dir}/${patch_file}":
          ensure => file,
          source => "${mountPoint}/${patch_file}",
          backup => false,
          mode   => '0775',
          owner  => $os_user,
          group  => $os_group,
          before => Wls_opatch["${oracle_product_home_dir}:${patch_id}"],
          #         before => Exec["extract opatch ${patch_file} ${title}"],
          }
      }
      $disk1_file = "${download_dir}/${patch_file}"
    } else {
      $disk1_file = "${source}/${patch_file}"
    }

    # exec { "extract opatch ${patch_file} ${title}":
    #   command   => "unzip -n ${disk1_file} -d ${download_dir}",
    #   creates   => "${download_dir}/${patch_id}",
    #   path      => $exec_path,
    #   user      => $os_user,
    #   group     => $os_group,
    #   logoutput => false,
    #   before    => Opatch["${patch_id} ${title}"],
    # }
    } else {
      $disk1_file = undef
    }

    case $::kernel {
      'Linux': {
        $oraInstPath = '/etc'
      }
      'SunOS': {
        $oraInstPath = '/var/opt/oracle'
      }
      default: {
        fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
      }
    }

    wls_opatch{"${oracle_product_home_dir}:${patch_id}":
      ensure       => $ensure,
      os_user      => $os_user,
      source       => $disk1_file,
      jdk_home_dir => $jdk_home_dir,
      orainst_dir  => $oraInstPath,
      tmp_dir      => $download_dir,
    }

    # opatch{ "${patch_id} ${title}":
    #   ensure                  => $ensure,
    #   patch_id                => $patch_id,
    #   os_user                 => $os_user,
    #   oracle_product_home_dir => $oracle_product_home_dir,
    #   orainst_dir             => $oraInstPath,
    #   jdk_home_dir            => $jdk_home_dir,
    #   extracted_patch_dir     => "${download_dir}/${patch_id}",
    # }

    }
