# == Define: orawls::fmw
#
# installs FMW software like ADF,OIM,WC,WCC,OSB & SOA Suite
#
##
define orawls::fmw (
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'     , undef), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir'   , undef), # /opt/oracle/middleware11gR1
  $oracle_base_home_dir       = hiera('wls_oracle_base_home_dir'  , undef), # /opt/oracle
  $jdk_home_dir               = hiera('wls_jdk_home_dir'          , undef), # /usr/java/jdk1.7.0_45
  $fmw_product                = undef,                                      # adf|soa|osb
  $fmw_file1                  = undef,
  $fmw_file2                  = undef,
  $os_user                    = hiera('wls_os_user'               , undef), # oracle
  $os_group                   = hiera('wls_os_group'              , undef), # dba
  $download_dir               = hiera('wls_download_dir'          , undef), # /data/install
  $source                     = hiera('wls_source'                , undef), # puppet:///modules/orawls/ | /mnt | /vagrant
  $remote_file                = true,                                       # true|false
  $log_output                 = false,                                      # true|false
)
{

  $exec_path     = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"
  $oraInventory  = "${oracle_base_home_dir}/oraInventory"

  case $::kernel {
    Linux: {
      $installDir    = "linux64"
      $oraInstPath   = "/etc"
   }
    SunOS: {
      case $::architecture {
        i86pc: {
          $oraInstPath   = "/var/opt"
          $installDir    = "intelsolaris"
        }
        default: {
          $oraInstPath   = "/var/opt"
          $installDir    = "solaris"
        }
      }
    }
  }

  if      ( $fmw_product == "adf" ) {
     $fmw_silent_response_file = "orawls/fmw_silent_adf.rsp.erb"
     $oracleHome               = "${middleware_home_dir}/oracle_common"
     $total_files              = 1
     $last_extract_check       = "extract ${fmw_file1}"
     $last_download_check      = "${download_dir}/${fmw_file1}"

  } elsif ( $fmw_product == "soa" ) {
     $fmw_silent_response_file = "orawls/fmw_silent_soa.rsp.erb"
     $oracleHome               = "${middleware_home_dir}/Oracle_SOA1"
     $total_files              = 2
     $last_extract_check       = "extract ${fmw_file2}"
     $last_download_check      = "${download_dir}/${fmw_file2}"

  } elsif ( $fmw_product == "osb" ) {
     $fmw_silent_response_file = "orawls/fmw_silent_osb.rsp.erb"
     $oracleHome               = "${middleware_home_dir}/Oracle_OSB1"
     $total_files              = 1
     $last_extract_check       = "extract ${fmw_file1}"
     $last_download_check      = "${download_dir}/${fmw_file1}"

  } elsif ( $fmw_product == "oim" ) {
     $fmw_silent_response_file = "orawls/fmw_silent_oim.rsp.erb"
     $oracleHome               = "${middleware_home_dir}/Oracle_IDM1"
     $total_files              = 2
     $last_extract_check       = "extract ${fmw_file2}"
     $last_download_check      = "${download_dir}/${fmw_file2}"

  } elsif ( $fmw_product == "wc" ) {
     $fmw_silent_response_file = "orawls/fmw_silent_wc.rsp.erb"
     $oracleHome               = "${middleware_home_dir}/Oracle_WC1"
     $total_files              = 1
     $last_extract_check       = "extract ${fmw_file1}"
     $last_download_check      = "${download_dir}/${fmw_file1}"

  } elsif ( $fmw_product == "wcc" ) {
     $fmw_silent_response_file = "orawls/fmw_silent_wcc.rsp.erb"
     $oracleHome               = "${middleware_home_dir}/Oracle_WCC1"
     $total_files              = 2
     $last_extract_check       = "extract ${fmw_file2}"
     $last_download_check      = "${download_dir}/${fmw_file2}"

  } else {
      fail('unknown fmw_product value choose adf|soa|osb|oim|wc|wcc')
  }


  # check if the oracle home already exists
  $found = oracle_exists($oracleHome)

  if $found == undef {
    $continue = true
  } else {
    if ($found) {
      $continue = false
    } else {
      notify { "orawls::fmw ${title} ${oracleHome} does not exists": }
      $continue = true
    }
  }

  if ($continue) {

    if $source == undef {
      $mountPoint = "puppet:///modules/orawls/"
    } else {
      $mountPoint = $source
    }

    orawls::utils::orainst { "create oraInst for ${fmw_product}":
      ora_inventory_dir => $oraInventory,
      os_group          => $os_group,
    }

    file { "${download_dir}/${title}_silent_${fmw_product}.rsp":
      ensure  => present,
      content => template($fmw_silent_response_file),
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
      require => Orawls::Utils::Orainst["create oraInst for ${fmw_product}"],
    }

    # for performance reasons, download and extract or just extract it
    if $remote_file == true {
      file { "${download_dir}/${fmw_file1}":
        ensure  => present,
        source  => "${mountPoint}/${fmw_file1}",
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
        backup  => false,
      }
      exec { "extract ${fmw_file1}":
        command   => "unzip -o ${download_dir}/${fmw_file1} -d ${download_dir}/${fmw_product}",
        creates   => "${download_dir}/${fmw_product}/Disk1",
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        logoutput => false,
        require   => File["${download_dir}/${fmw_file1}"],
      }
    } else {
      exec { "extract ${fmw_file1}":
        command   => "unzip -o ${source}/${fmw_file1} -d ${download_dir}/${fmw_product}",
        creates   => "${download_dir}/${fmw_product}/Disk1",
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        logoutput => false,
      }
    }

    if ( $total_files > 1 ) {

      # for performance reasons, download and extract or just extract it
      if $remote_file == true {

        file { "${download_dir}/${fmw_file2}":
          ensure  => present,
          source  => "${mountPoint}/${fmw_file2}",
          mode    => '0775',
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          require => [File["${download_dir}/${fmw_file1}"],
                      Exec["extract ${fmw_file1}"]
                     ],
        }
        exec { "extract ${fmw_file2}":
          command   => "unzip -o ${download_dir}/${fmw_file2} -d ${download_dir}/${fmw_product}",
          path      => $exec_path,
          user      => $os_user,
          group     => $os_group,
          logoutput => false,
          require   => [File["${download_dir}/${fmw_file2}"],
                        Exec["extract ${fmw_file1}"]
                       ],
        }
      } else {
        exec { "extract ${fmw_file2}":
          command   => "unzip -o ${source}/${fmw_file2} -d ${download_dir}/${fmw_product}",
          path      => $exec_path,
          user      => $os_user,
          group     => $os_group,
          logoutput => false,
        }
      }
    }

    if $::kernel == "SunOS" {

      if $fmw_product == "soa" {
        exec { "add -d64 oraparam.ini ${title}":
          command   => "sed -e's/JRE_MEMORY_OPTIONS=\" -Xverify:none\"/JRE_MEMORY_OPTIONS=\"-d64 -Xverify:none\"/g' ${download_dir}/${fmw_product}/Disk1/install/${installDir}/oraparam.ini > /tmp/soa.tmp && mv /tmp/soa.tmp ${download_dir}/${fmw_product}/Disk1/install/${installDir}/oraparam.ini",
          require   => [Exec["extract ${fmw_file1}"],
                        Exec["extract ${fmw_file1}"],
                       ],
          before    => Exec["install ${fmw_product} ${title}"],
          path      => $exec_path,
          user      => $os_user,
          group     => $os_group,
          logoutput => $log_output,
        }
      }
      if $fmw_product == "osb" {

        exec { "add -d64 oraparam.ini ${title}":
          command   => "sed -e's/\\[Oracle\\]/\\[Oracle\\]\\\nJRE_MEMORY_OPTIONS=\"-d64\"/g' ${download_dir}/${fmw_product}/Disk1/install/${installDir}/oraparam.ini > /tmp/osb.tmp && mv /tmp/osb.tmp ${download_dir}/${fmw_product}/Disk1/install/${installDir}/oraparam.ini",
          require   => Exec["extract ${fmw_file1}"],
          before    => Exec["install ${fmw_product} ${title}"],
          path      => $exec_path,
          user      => $os_user,
          group     => $os_group,
          logoutput => $log_output,
        }
      }
    }

    $command = "-silent -response ${download_dir}/${title}_silent_${fmw_product}.rsp -waitforcompletion "

    exec { "install ${fmw_product} ${title}":
      command   => "${download_dir}/${fmw_product}/Disk1/install/${installDir}/runInstaller ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs -jreLoc ${jdk_home_dir}",
      creates   => $oracleHome,
      timeout   => 0,
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
      require   => [File["${download_dir}/${title}_silent_${fmw_product}.rsp"],
                    Orawls::Utils::Orainst["create oraInst for ${fmw_product}"],
                    Exec[$last_extract_check]
                   ],
    }
  }
}
