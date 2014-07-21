# == Define: orawls::fmw
#
# installs FMW software like ADF,OIM,WC,WCC,OSB & SOA Suite
#
##
define orawls::fmw (
  $version                    = hiera('wls_version'               , 1111),  # 1036|1111|1211|1212|1213
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $oracle_base_home_dir       = hiera('wls_oracle_base_home_dir'), # /opt/oracle
  $oracle_home_dir            = undef,                                      # /opt/oracle/middleware/Oracle_SOA
  $jdk_home_dir               = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $fmw_product                = undef,                                      # adf|soa|osb|wcc|wc|oim|web|webgate|oud|mft|b2b
  $fmw_file1                  = undef,
  $fmw_file2                  = undef,
  $bpm                        = false,
  $healthcare                 = false,
  $os_user                    = hiera('wls_os_user'), # oracle
  $os_group                   = hiera('wls_os_group'), # dba
  $download_dir               = hiera('wls_download_dir'), # /data/install
  $source                     = hiera('wls_source'                , undef), # puppet:///modules/orawls/ | /mnt | /vagrant
  $remote_file                = true,                                       # true|false
  $log_output                 = false,                                      # true|false
  $temp_directory             = hiera('wls_temp_dir'              ,'/tmp'), # /tmp directory
)
{
  $exec_path     = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"
  $oraInventory  = "${oracle_base_home_dir}/oraInventory"

  case $::kernel {
    'Linux': {
      $oraInstPath   = '/etc'
      case $::architecture {
        'i386': {
          $installDir   = 'linux'
        }
        default: {
          $installDir   = 'linux64'
        }
      }
    }
    'SunOS': {
      $oraInstPath   = '/var/opt/oracle'
      case $::architecture {
        'i86pc': {
          $installDir    = 'intelsolaris'
        }
        default: {
          $installDir    = 'solaris'
        }
      }
    }
    default: {
      fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
    }

  }

  if ( $fmw_product == 'adf' ) {
    $fmw_silent_response_file = 'orawls/fmw_silent_adf.rsp.erb'
    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/oracle_common"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $createFile1 = "${download_dir}/${fmw_product}/Disk1"
    $total_files = 1

  } elsif ( $fmw_product == 'soa' ) {

    if $version == 1213 {
      $total_files = 1
      $fmw_silent_response_file = 'orawls/fmw_silent_soa_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_soa.jar'
      $createFile1              = "${download_dir}/${fmw_product}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/soa/bin"
      $type                     = 'java'
      if $bpm == true {
        $install_type = 'BPM'
      } else {
        $install_type = 'SOA Suite'
      }

    } else {
      $total_files = 2
      $fmw_silent_response_file = 'orawls/fmw_silent_soa.rsp.erb'
      $createFile1 = "${download_dir}/${fmw_product}/Disk1"
      $createFile2 = "${download_dir}/${fmw_product}/Disk4"
      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/Oracle_SOA1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
    }

  } elsif ( $fmw_product == 'osb' ) {

    $total_files = 1
    if $version == 1213 {
      $fmw_silent_response_file = 'orawls/fmw_silent_osb_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_osb.jar'
      $createFile1              = "${download_dir}/${fmw_product}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/osb/bin"
      $type                     = 'java'
    } else {
      $fmw_silent_response_file = 'orawls/fmw_silent_osb.rsp.erb'
      $createFile1 = "${download_dir}/${fmw_product}/Disk1"
      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/Oracle_OSB1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
    }
  } elsif ( $fmw_product == 'b2b' ) {

    if $version == 1213 {
      $total_files = 1
      $fmw_silent_response_file = 'orawls/fmw_silent_b2b_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_b2bhealthcare.jar'
      $createFile1              = "${download_dir}/${fmw_product}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/soa/soa/modules/oracle.soa.b2b_11.1.1/b2b.jar"
      $type                     = 'java'
      if $healthcare == true {
        $install_type = 'Healthcare'
      } else {
        $install_type = 'B2B'
      }
    } else {
      fail('Unrecognized version for b2b')
    }
  } elsif ( $fmw_product == 'mft' ) {

    if $version == 1213 {
      $total_files = 1
      $fmw_silent_response_file = 'orawls/fmw_silent_mft_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_mft.jar'
      $createFile1              = "${download_dir}/${fmw_product}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/mft/bin"
      $type                     = 'java'

    } else {
      fail('Unrecognized version for mft')
    }

  } elsif ( $fmw_product == 'oim' ) {
    $fmw_silent_response_file = 'orawls/fmw_silent_oim.rsp.erb'
    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/Oracle_IDM1"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $createFile1 = "${download_dir}/${fmw_product}/Disk1"
    $createFile2 = "${download_dir}/${fmw_product}/Disk4"
    $total_files = 2

  } elsif ( $fmw_product == 'wc' ) {
    $fmw_silent_response_file = 'orawls/fmw_silent_wc.rsp.erb'
    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/Oracle_WC1"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $createFile1 = "${download_dir}/${fmw_product}/Disk1"
    $total_files = 1

  } elsif ( $fmw_product == 'wcc' ) {
    $fmw_silent_response_file = 'orawls/fmw_silent_wcc.rsp.erb'
    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/Oracle_WCC1"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $createFile1 = "${download_dir}/${fmw_product}/Disk1"
    $createFile2 = "${download_dir}/${fmw_product}/Disk2"
    $total_files = 2

  } elsif ( $fmw_product == 'web') {

    if $version == 1212 {
      $fmw_silent_response_file = 'orawls/web_http_server_1212.rsp.erb'
      $binFile1                 = 'ohs_121200_linux64.bin'
      $createFile1              = "${download_dir}/${fmw_product}/${binFile1}"
      $type                     = 'bin'
    }
    elsif $version == 1213 {
      $fmw_silent_response_file = 'orawls/web_http_server_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_ohs_linux64.bin'
      $createFile1              = "${download_dir}/${fmw_product}/${binFile1}"
      $type                     = 'bin'
    } else {
      $fmw_silent_response_file = 'orawls/web_http_server.rsp.erb'
      $createFile1              = "${download_dir}/${fmw_product}/Disk1"
    }

    if ($oracle_home_dir == undef) {
      if $version == 1212 or $version == 1213 {
        $oracleHome = "${middleware_home_dir}/ohs"
      } else {
        $oracleHome = "${middleware_home_dir}/Oracle_WT1"
      }
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $total_files = 1

  } elsif ( $fmw_product == 'webgate' ) {

    $fmw_silent_response_file = 'orawls/fmw_webgate.rsp.erb'
    $createFile1              = "${download_dir}/${fmw_product}/Disk1"

    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/Oracle_OAMWebGate1"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $total_files = 1

  } elsif ( $fmw_product == 'oud' ) {

    $fmw_silent_response_file = 'orawls/fmw_silent_oud.rsp.erb'
    $createFile1              = "${download_dir}/${fmw_product}/Disk1"

    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/Oracle_OUD1"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $total_files = 1

  } else {
    fail('unknown fmw_product value choose adf|soa|osb|oim|wc|wcc|web|webgate|oud')
  }

  # check if the oracle home already exists, only for < 12.1.2, this is for performance reasons
  if $version == 1212 or $version == 1213 {
    $continue = true
  } else {
    $found = orawls_oracle_exists($oracleHome)

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
  }

  if ($continue) {

    if $source == undef {
      $mountPoint = 'puppet:///modules/orawls/'
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
        ensure   => file,
        source   => "${mountPoint}/${fmw_file1}",
        mode     => '0775',
        owner    => $os_user,
        group    => $os_group,
        backup   => false,
        before   => Exec["extract ${fmw_file1}"],
      }
      $disk1_file = "${download_dir}/${fmw_file1}"
    } else {
      $disk1_file = "${source}/${fmw_file1}"
    }

    exec { "extract ${fmw_file1}":
      command   => "unzip -o ${disk1_file} -d ${download_dir}/${fmw_product}",
      creates   => $createFile1,
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => false,
      require   => Orawls::Utils::Orainst["create oraInst for ${fmw_product}"],
    }

    if ( $total_files > 1 ) {

      # for performance reasons, download and extract or just extract it
      if $remote_file == true {

        file { "${download_dir}/${fmw_file2}":
          ensure   => file,
          source   => "${mountPoint}/${fmw_file2}",
          mode     => '0775',
          owner    => $os_user,
          group    => $os_group,
          backup   => false,
          before   => Exec["extract ${fmw_file2}"],
          require  => [File["${download_dir}/${fmw_file1}"],
                      Exec["extract ${fmw_file1}"]],
        }
        $disk2_file = "${download_dir}/${fmw_file2}"
      } else {
        $disk2_file = "${source}/${fmw_file2}"
      }

      exec { "extract ${fmw_file2}":
        command   => "unzip -o ${disk2_file} -d ${download_dir}/${fmw_product}",
        creates   => $createFile2,
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        logoutput => false,
        require   => Exec["extract ${fmw_file1}"],
        before    => Exec["install ${fmw_product} ${title}"],
      }
    }

    if $::kernel == 'SunOS' {
      if $version != 1213 {
        if $fmw_product == 'soa' {
          exec { "add -d64 oraparam.ini ${title}":
            command   => "sed -e's/JRE_MEMORY_OPTIONS=\" -Xverify:none\"/JRE_MEMORY_OPTIONS=\"-d64 -Xverify:none\"/g' ${download_dir}/${fmw_product}/Disk1/install/${installDir}/oraparam.ini > /tmp/soa.tmp && mv /tmp/soa.tmp ${download_dir}/${fmw_product}/Disk1/install/${installDir}/oraparam.ini",
            unless    => "grep 'JRE_MEMORY_OPTIONS=\"-d64' ${download_dir}/${fmw_product}/Disk1/install/${installDir}/oraparam.ini",
            require   => [Exec["extract ${fmw_file1}"],
                          Exec["extract ${fmw_file2}"],],
            before    => Exec["install ${fmw_product} ${title}"],
            path      => $exec_path,
            user      => $os_user,
            group     => $os_group,
            logoutput => $log_output,
          }
        }
        if $fmw_product == 'osb' {
          exec { "add -d64 oraparam.ini ${title}":
            command   => "sed -e's/\\[Oracle\\]/\\[Oracle\\]\\\nJRE_MEMORY_OPTIONS=\"-d64\"/g' ${download_dir}/${fmw_product}/Disk1/install/${installDir}/oraparam.ini > /tmp/osb.tmp && mv /tmp/osb.tmp ${download_dir}/${fmw_product}/Disk1/install/${installDir}/oraparam.ini",
            unless    => "grep 'JRE_MEMORY_OPTIONS=\"-d64\"' ${download_dir}/${fmw_product}/Disk1/install/${installDir}/oraparam.ini",
            require   => Exec["extract ${fmw_file1}"],
            before    => Exec["install ${fmw_product} ${title}"],
            path      => $exec_path,
            user      => $os_user,
            group     => $os_group,
            logoutput => $log_output,
          }
        }
      }
    }

    $command = "-silent -response ${download_dir}/${title}_silent_${fmw_product}.rsp -waitforcompletion"

    #notify { "orawls::fmw ${download_dir}/${fmw_product}/Disk1/install/${installDir}/runInstaller ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs -jreLoc ${jdk_home_dir} -Djava.io.tmpdir=${temp_directory}": }
    if $version == 1212 or $version == 1213 {
      if $type == 'java' {
        $install = 'java -jar '
      }
      else {
        $install = ''
      }

      exec { "install ${fmw_product} ${title}":
        command     => "${install}${download_dir}/${fmw_product}/${binFile1} ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs -jreLoc ${jdk_home_dir}",
        environment => "TMP=${temp_directory}",
        timeout     => 0,
        creates     => $oracleHome,
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [File["${download_dir}/${title}_silent_${fmw_product}.rsp"],
                        Orawls::Utils::Orainst["create oraInst for ${fmw_product}"],
                        Exec["extract ${fmw_file1}"],],
      }
    } else {
      file { $oracleHome:
        ensure => 'directory',
        owner  => $os_user,
        group  => $os_group,
        before => Exec["install ${fmw_product} ${title}"],
      }

      exec { "install ${fmw_product} ${title}":
        command     => "${download_dir}/${fmw_product}/Disk1/install/${installDir}/runInstaller ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs -jreLoc ${jdk_home_dir} -Djava.io.tmpdir=${temp_directory}",
        environment => "TMP=${temp_directory}",
        timeout     => 0,
        creates     => "${oracleHome}/OPatch",
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [File["${download_dir}/${title}_silent_${fmw_product}.rsp"],
                        Orawls::Utils::Orainst["create oraInst for ${fmw_product}"],
                        Exec["extract ${fmw_file1}"],],
      }

      ## fix EditHttpConf in OHS Webgate
      if ( $version == 1112 and $fmw_product == 'webgate' ) {
        exec { "install ${fmw_product} ${title} EditHttpConf1":
          command     => "unzip -o -j '${download_dir}/${fmw_product}/Disk1/stage/Components/oracle.as.oam.webgate.ohs_linux64/11.1.2.2.0/1/DataFiles/filegroup1.jar' 'webgate/ohs/lib/libxmlengine.so' -d '${oracleHome}/webgate/ohs/lib/'",
          timeout     => 0,
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          logoutput   => $log_output,
          require     => Exec["install ${fmw_product} ${title}"],
        }
        exec { "install ${fmw_product} ${title} EditHttpConf2":
          command     => "unzip -o -j '${download_dir}/${fmw_product}/Disk1/stage/Components/oracle.as.oam.webgate.ohs_linux64/11.1.2.2.0/1/DataFiles/filegroup1.jar' 'webgate/ohs/lib/webgate.so' -d '${oracleHome}/webgate/ohs/lib/'",
          timeout     => 0,
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          logoutput   => $log_output,
          require     => Exec["install ${fmw_product} ${title}"],
        }
        exec { "install ${fmw_product} ${title} EditHttpConf3":
          command     => "unzip -o -j '${download_dir}/${fmw_product}/Disk1/stage/Components/oracle.as.oam.webgate.ohs_linux64/11.1.2.2.0/1/DataFiles/filegroup1.jar' 'webgate/ohs/tools/setup/InstallTools/EditHttpConf' -d '${oracleHome}/webgate/ohs/tools/setup/InstallTools/'",
          timeout     => 0,
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          logoutput   => $log_output,
          require     => Exec["install ${fmw_product} ${title}"],
        }
        file { "${oracleHome}/webgate/ohs/tools/setup/InstallTools/EditHttpConf":
          ensure   => file,
          mode     => '0775',
          owner    => $os_user,
          group    => $os_group,
          backup   => false,
          require  => Exec["install ${fmw_product} ${title} EditHttpConf3"],
        }
      }
    }
  }
}
