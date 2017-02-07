# == Define: orawls::fmw
#
# installs FMW software like ADF, FORMS, OIM, WC, WCC, OSB, SOA Suite, B2B, MFT
#
##
define orawls::fmw(
  $version              = hiera('wls_version', 1111),        # 1036|1111|1211|1212|1213|1221|12211|12212
  $weblogic_home_dir    = hiera('wls_weblogic_home_dir'),    # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir  = hiera('wls_middleware_home_dir'),  # /opt/oracle/middleware11gR1
  $oracle_base_home_dir = hiera('wls_oracle_base_home_dir'), # /opt/oracle
  $oracle_home_dir      = undef,                             # /opt/oracle/middleware/Oracle_SOA
  $jdk_home_dir         = hiera('wls_jdk_home_dir'),         # /usr/java/jdk1.7.0_45
  $fmw_product          = undef,                             # adf|soa|soaqs|osb|wcc|wc|oim|oam|web|webgate|oud|mft|b2b|forms
  $fmw_file1            = undef,
  $fmw_file2            = undef,
  $fmw_file3            = undef,
  $fmw_file4            = undef,
  $bpm                  = false,
  $healthcare           = false,
  $os_user              = hiera('wls_os_user'),              # oracle
  $os_group             = hiera('wls_os_group'),             # dba
  $download_dir         = hiera('wls_download_dir'),         # /data/install
  $source               = hiera('wls_source', undef),        # puppet:///modules/orawls/ | /mnt | /vagrant
  $remote_file          = true,                              # true|false
  $log_output           = false,                             # true|false
  $temp_directory       = hiera('wls_temp_dir','/tmp'),      # /tmp directory
  $ohs_mode             = hiera('ohs_mode', 'collocated'),
  $oracle_inventory_dir = undef,
  $orainstpath_dir      = hiera('orainstpath_dir', undef),
)
{
  $exec_path    = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

  if $oracle_inventory_dir == undef {
    $oraInventory = "${oracle_base_home_dir}/oraInventory"
  } else {
    $oraInventory = $oracle_inventory_dir
  }

  case $::kernel {
    'Linux': {
      if ( $orainstpath_dir == undef or $orainstpath_dir == '' ){
        $oraInstPath = '/etc'
      } else {
        $oraInstPath = $orainstpath_dir
      }
      case $::architecture {
        'i386': {
          $installDir = 'linux'
        }
        default: {
          $installDir = 'linux64'
        }
      }
    }
    'SunOS': {
      $oraInstPath = '/var/opt/oracle'
      case $::architecture {
        'i86pc': {
          $installDir = 'intelsolaris'
        }
        default: {
          $installDir = 'solaris'
        }
      }
    }
    default: {
      fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
    }

  }
  #Sanitise the resource title so that it can safely be used in filenames and execs etc.
  #After converting all spaces to underscores, remove all non alphanumeric characters (allow hypens and underscores too)
  $convert_spaces_to_underscores = regsubst($title,'\s','_','G')
  $sanitised_title = regsubst ($convert_spaces_to_underscores,'[^a-zA-Z0-9_-]','','G')

  if ( $fmw_product == 'adf' ) {
    $fmw_silent_response_file = 'orawls/fmw_silent_adf.rsp.erb'
    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/oracle_common"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
    $total_files = 1

  } elsif ( $fmw_product == 'forms' ) {

    if $version >= 1221 {
      $fmw_silent_response_file = 'orawls/fmw_silent_forms_1221.rsp.erb'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_fr_linux64.bin'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_fr_linux64.bin'
      } else {
        $binFile1                 = 'fmw_12.2.1.2.0_fr_linux64.bin'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'bin'
      $total_files              = 1
      $install_type             = 'Forms and Reports Deployment'
      $oracleHome               = "${middleware_home_dir}/forms"
    }
    else {
      $fmw_silent_response_file = 'orawls/fmw_silent_forms.rsp.erb'

      $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
      if $version == 11112 {
        $total_files = 4
        $createFile2 = "${download_dir}/${sanitised_title}/Disk2"
        $createFile3 = "${download_dir}/${sanitised_title}/Disk3"
        $createFile4 = "${download_dir}/${sanitised_title}/Disk4"
      }
      elsif $version == 1112  {
        $total_files = 2
        $createFile2 = "${download_dir}/${sanitised_title}/Disk4"
      }
      else {
        $total_files = 1
      }

      if ($oracle_home_dir == undef) {
          $oracleHome = "${middleware_home_dir}/Oracle_FRM1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
    }

  } elsif ( $fmw_product == 'soa' ) {

    if $version >= 1221 {
      $total_files = 1
      $fmw_silent_response_file = 'orawls/fmw_silent_soa_1221.rsp.erb'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_soa.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_soa.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.2.0_soa.jar'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/soa/bin"
      $type                     = 'java'
      if $bpm == true {
        $install_type = 'BPM'
      } else {
        $install_type = 'SOA Suite'
      }
    }
    elsif $version == 1213 {
      $total_files = 1
      $fmw_silent_response_file = 'orawls/fmw_silent_soa_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_soa.jar'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/soa/bin"
      $type                     = 'java'
      if $bpm == true {
        $install_type = 'BPM'
      } else {
        $install_type = 'SOA Suite'
      }
    }
    else {
      $total_files = 2
      $fmw_silent_response_file = 'orawls/fmw_silent_soa.rsp.erb'
      $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
      $createFile2 = "${download_dir}/${sanitised_title}/Disk4"
      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/Oracle_SOA1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
    }

  } elsif ( $fmw_product == 'soaqs' ) {

    if $version >= 1221 {
      $total_files = 2
      $fmw_silent_response_file = 'orawls/fmw_silent_soa_1221.rsp.erb'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_soa_quickstart.jar'
        $binFile2                 = 'fmw_12.2.1.0.0_soa_quickstart2.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_soa_quickstart.jar'
        $binFile2                 = 'fmw_12.2.1.1.0_soa_quickstart2.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.2.0_soa_quickstart.jar'
        $binFile2                 = 'fmw_12.2.1.2.0_soa_quickstart2.jar'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $createFile2              = "${download_dir}/${sanitised_title}/${binFile2}"
      $oracleHome               = "${middleware_home_dir}/soa/bin"
      $type                     = 'java'
      if $bpm == true {
        $install_type = 'BPM'
      } else {
        $install_type = 'SOA Suite'
      }
    }
    elsif $version == 1213 {
      $total_files = 1
      $fmw_silent_response_file = 'orawls/fmw_silent_soa_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_soa_quickstart.jar'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/soa/bin"
      $type                     = 'java'
      if $bpm == true {
        $install_type = 'BPM'
      } else {
        $install_type = 'SOA Suite'
      }
    }
    else {
      fail('Unrecognized version for soaqs')
    }

  } elsif ( $fmw_product == 'osb' ) {

    $total_files = 1
    if $version >= 1221 {
      $fmw_silent_response_file = 'orawls/fmw_silent_osb_1221.rsp.erb'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_osb.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_osb.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.2.0_osb.jar'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/osb/bin"
      $type                     = 'java'
    }
    elsif $version == 1213 {
      $fmw_silent_response_file = 'orawls/fmw_silent_osb_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_osb.jar'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/osb/bin"
      $type                     = 'java'
    }
    else {
      $fmw_silent_response_file = 'orawls/fmw_silent_osb.rsp.erb'
      $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/Oracle_OSB1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
    }
  }
  elsif ( $fmw_product == 'b2b' ) {
    if $healthcare == true {
      $install_type = 'Healthcare'
    } else {
      $install_type = 'B2B'
    }

    if $version == 1213 {
      $total_files = 1
      $fmw_silent_response_file = 'orawls/fmw_silent_b2b_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_b2bhealthcare.jar'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/soa/soa/modules/oracle.soa.b2b_11.1.1/b2b.jar"
      $type                     = 'java'
    }
    elsif $version >= 1221 {
      $total_files = 1
      $fmw_silent_response_file = 'orawls/fmw_silent_b2b_1221.rsp.erb'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_b2bhealthcare.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_b2bhealthcare.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.2.0_b2bhealthcare.jar'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/soa/soa/modules/oracle.soa.b2b_11.1.1/b2b.jar"
      $type                     = 'java'
    }
    else {
      fail('Unrecognized version for b2b')
    }
  } elsif ( $fmw_product == 'mft' ) {

    if $version == 1213 {
      $total_files = 1
      $fmw_silent_response_file = 'orawls/fmw_silent_mft_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_mft.jar'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/mft/bin"
      $type                     = 'java'

    } else {
      fail('Unrecognized version for mft')
    }

  } elsif ( ( $fmw_product == 'oim' ) or ( $fmw_product == 'oam' ) ) {

    $fmw_silent_response_file = 'orawls/fmw_silent_oim.rsp.erb'
    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/Oracle_IDM1"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
    $createFile2 = "${download_dir}/${sanitised_title}/Disk4"
    $total_files = 3


  } elsif ( $fmw_product == 'wc' ) {

    if $version >= 1221 {
      $fmw_silent_response_file = 'orawls/fmw_silent_wc_1221.rsp.erb'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_wcportal_generic.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_wcportal_generic.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.2.0_wcportal_generic.jar'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'java'
      $total_files              = 1
      $oracleHome               = "${middleware_home_dir}/wcportal"
      $install_type             = 'WebCenter Portal'
    }
    else {
      $fmw_silent_response_file = 'orawls/fmw_silent_wc.rsp.erb'
      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/Oracle_WC1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
      $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
      $total_files = 1
    }

  } elsif ( $fmw_product == 'wcc' ) {

    if $version >= 1221 {
      $fmw_silent_response_file = 'orawls/fmw_silent_wcc_1221.rsp.erb'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_wccontent_generic.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_wccontent_generic.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.2.0_wccontent_generic.jar'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'java'
      $total_files              = 1
      $oracleHome               = "${middleware_home_dir}/wccontent"
    }
    else {
      $fmw_silent_response_file = 'orawls/fmw_silent_wcc.rsp.erb'
      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/Oracle_WCC1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
      $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
      $createFile2 = "${download_dir}/${sanitised_title}/Disk2"
      $total_files = 2
    }

  } elsif ( $fmw_product == 'web') {

    if ($ohs_mode == 'standalone') {
      $install_type = 'Standalone HTTP Server (Managed independently of WebLogic server)'
    } elsif ($ohs_mode in ['colocated','collocated']) {
      if $version == 1212 {
        $install_type = 'Colocated HTTP Server (Managed through WebLogic server)'
      } else {
        $install_type = 'Collocated HTTP Server (Managed through WebLogic server)'
      }
    } else {
      fail("Unrecognized parameter ohs_mode: ${ohs_mode}, please use colocated|collocated|standalone")
    }

    if $version == 1212 {
      $fmw_silent_response_file = 'orawls/web_http_server_1212.rsp.erb'
      $binFile1                 = 'ohs_121200_linux64.bin'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'bin'
    }
    elsif $version == 1213 {
      $fmw_silent_response_file = 'orawls/web_http_server_1213.rsp.erb'
      $binFile1                 = 'fmw_12.1.3.0.0_ohs_linux64.bin'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'bin'
    }
    elsif $version >= 1221 {
      $fmw_silent_response_file = 'orawls/web_http_server_1221.rsp.erb'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_ohs_linux64.bin'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_ohs_linux64.bin'
      } else {
        $binFile1                 = 'fmw_12.2.1.2.0_ohs_linux64.bin'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'bin'
    }
    else {
      $fmw_silent_response_file = 'orawls/web_http_server.rsp.erb'
      $createFile1              = "${download_dir}/${sanitised_title}/Disk1"
    }

    if ($oracle_home_dir == undef) {
      if ( $version == 1212 or $version == 1213 or $version >= 1221 ) {
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
    $createFile1              = "${download_dir}/${sanitised_title}/Disk1"

    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/Oracle_OAMWebGate1"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $total_files = 1

  } elsif ( $fmw_product == 'oud' ) {

    $fmw_silent_response_file = 'orawls/fmw_silent_oud.rsp.erb'
    $createFile1              = "${download_dir}/${sanitised_title}/Disk1"

    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/Oracle_OUD1"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $total_files = 1

  } else {
    fail('unknown fmw_product value choose adf|soa|soaqs|osb|oim|oam|wc|wcc|web|webgate|oud')
  }

  # check if the oracle home already exists, only for < 12.1.2, this is for performance reasons
  if $version == 1212 or $version == 1213 or $version >= 1221 {
    $continue = true
  } else {
    $found = orawls_oracle_exists($oracleHome)

    if $found == undef {
      $continue = true
    } else {
      if ($found) {
        $continue = false
      } else {
        notify { "orawls::fmw ${sanitised_title} ${oracleHome} does not exists": }
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

    orawls::utils::orainst { "create oraInst for ${name}":
      ora_inventory_dir => $oraInventory,
      os_group          => $os_group,
    }

    file { "${download_dir}/${sanitised_title}_silent.rsp":
      ensure  => present,
      content => template($fmw_silent_response_file),
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
      require => Orawls::Utils::Orainst["create oraInst for ${name}"],
    }

    # for performance reasons, download and extract or just extract it
    if $remote_file == true {
      file { "${download_dir}/${fmw_file1}":
        ensure => file,
        source => "${mountPoint}/${fmw_file1}",
        mode   => '0775',
        owner  => $os_user,
        group  => $os_group,
        backup => false,
        before => Exec["extract ${fmw_file1} for ${name}"],
      }
      $disk1_file = "${download_dir}/${fmw_file1}"
    } else {
      $disk1_file = "${source}/${fmw_file1}"
    }

    exec { "extract ${fmw_file1} for ${name}":
      command   => "unzip -o ${disk1_file} -d ${download_dir}/${sanitised_title}",
      creates   => $createFile1,
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      timeout   => 0,
      cwd       => $temp_directory,
      logoutput => false,
      require   => Orawls::Utils::Orainst["create oraInst for ${name}"],
    }

    # TODO: we should make a utility function to handle each file rather than copy/pasting and editing
    if ( $total_files > 1 ) {

      # for performance reasons, download and extract or just extract it
      if $remote_file == true {

        file { "${download_dir}/${fmw_file2}":
          ensure  => file,
          source  => "${mountPoint}/${fmw_file2}",
          mode    => '0775',
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          before  => Exec["extract ${fmw_file2} for ${name}"],
          require => [File["${download_dir}/${fmw_file1}"],
                      Exec["extract ${fmw_file1} for ${name}"],],
        }
        $disk2_file = "${download_dir}/${fmw_file2}"
      } else {
        $disk2_file = "${source}/${fmw_file2}"
      }

      exec { "extract ${fmw_file2} for ${name}":
        command   => "unzip -o ${disk2_file} -d ${download_dir}/${sanitised_title}",
        creates   => $createFile2,
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        timeout   => 0,
        cwd       => $temp_directory,
        logoutput => false,
        require   => Exec["extract ${fmw_file1} for ${name}"],
        before    => Exec["install ${sanitised_title}"],
      }
    }
    if ( $total_files > 2 ) {

      # for performance reasons, download and extract or just extract it
      if $remote_file == true {

        file { "${download_dir}/${fmw_file3}":
          ensure  => file,
          source  => "${mountPoint}/${fmw_file3}",
          mode    => '0775',
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          before  => Exec["extract ${fmw_file3}"],
          require => [File["${download_dir}/${fmw_file2}"],
                      Exec["extract ${fmw_file2}"],],
        }
        $disk3_file = "${download_dir}/${fmw_file3}"
      } else {
        $disk3_file = "${source}/${fmw_file3}"
      }

      exec { "extract ${fmw_file3} for ${name}":
        command   => "unzip -o ${disk3_file} -d ${download_dir}/${sanitised_title}",
        creates   => $createFile3,
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        timeout   => 0,
        cwd       => $temp_directory,
        logoutput => false,
        require   => Exec["extract ${fmw_file2} for ${name}"],
        before    => Exec["install ${sanitised_title}"],
      }
    }
    if ( $total_files > 3 ) {

      # for performance reasons, download and extract or just extract it
      if $remote_file == true {

        file { "${download_dir}/${fmw_file4}":
          ensure  => file,
          source  => "${mountPoint}/${fmw_file4}",
          mode    => '0775',
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          before  => Exec["extract ${fmw_file4}"],
          require => [File["${download_dir}/${fmw_file3}"],
                      Exec["extract ${fmw_file3} for ${name}"],],
        }
        $disk4_file = "${download_dir}/${fmw_file4}"
      } else {
        $disk4_file = "${source}/${fmw_file4}"
      }

      exec { "extract ${fmw_file4} for ${name}":
        command   => "unzip -o ${disk4_file} -d ${download_dir}/${sanitised_title}",
        creates   => $createFile4,
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        timeout   => 0,
        cwd       => $temp_directory,
        logoutput => false,
        require   => Exec["extract ${fmw_file3} for ${name}"],
        before    => Exec["install ${sanitised_title}"],
      }
    }

    if $::kernel == 'SunOS' {
      if $version != 1213 {
        if $fmw_product == 'soa' {
          exec { "add -d64 oraparam.ini ${sanitised_title}":
            command   => "sed -e's/JRE_MEMORY_OPTIONS=\" -Xverify:none\"/JRE_MEMORY_OPTIONS=\"-d64 -Xverify:none\"/g' ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini > ${temp_directory}/soa.tmp && mv ${temp_directory}/soa.tmp ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini",
            unless    => "grep 'JRE_MEMORY_OPTIONS=\"-d64' ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini",
            require   => Exec["extract ${fmw_file1} for ${name}","extract ${fmw_file2} for ${name}"],
            before    => Exec["install ${sanitised_title}"],
            path      => $exec_path,
            user      => $os_user,
            group     => $os_group,
            cwd       => $temp_directory,
            logoutput => $log_output,
          }
        }
        if $fmw_product == 'osb' {
          exec { "add -d64 oraparam.ini ${sanitised_title}":
            command   => "sed -e's/\\[Oracle\\]/\\[Oracle\\]\\\nJRE_MEMORY_OPTIONS=\"-d64\"/g' ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini > ${temp_directory}/osb.tmp && mv ${temp_directory}/osb.tmp ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini",
            unless    => "grep 'JRE_MEMORY_OPTIONS=\"-d64\"' ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini",
            require   => Exec["extract ${fmw_file1} for ${name}"],
            before    => Exec["install ${sanitised_title}"],
            path      => $exec_path,
            user      => $os_user,
            group     => $os_group,
            cwd       => $temp_directory,
            logoutput => $log_output,
          }
        }
      }
    }

    if $version >= 1221 {
      $command = "-silent -responseFile ${download_dir}/${sanitised_title}_silent.rsp"
    }
    else {
      $command = "-silent -response ${download_dir}/${sanitised_title}_silent.rsp -waitforcompletion"
    }

    if $version == 1212 or $version == 1213 or $version >= 1221 {
      if $type == 'java' {
        $install = "java -Djava.io.tmpdir=${temp_directory} -jar "
      }
      else {
        $install = ''
      }

      exec { "install ${sanitised_title}":
        command     => "${install}${download_dir}/${sanitised_title}/${binFile1} ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs -jreLoc ${jdk_home_dir}",
        environment => "TEMP=${temp_directory}",
        timeout     => 0,
        creates     => $oracleHome,
        cwd         => $temp_directory,
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [File["${download_dir}/${sanitised_title}_silent.rsp"],
                        Orawls::Utils::Orainst["create oraInst for ${name}"],
                        Exec["extract ${fmw_file1} for ${name}"],],
      }
    } else {
      if !defined(File[$oracleHome]) {
        file { $oracleHome:
          ensure => 'directory',
          owner  => $os_user,
          group  => $os_group,
          before => Exec["install ${sanitised_title}"],
        }
      }

      exec { "install ${sanitised_title}":
        command     => "/bin/sh -c 'unset DISPLAY;${download_dir}/${sanitised_title}/Disk1/install/${installDir}/runInstaller ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs -jreLoc ${jdk_home_dir} -Djava.io.tmpdir=${temp_directory}'",
        environment => "TEMP=${temp_directory}",
        timeout     => 0,
        creates     => "${oracleHome}/OPatch",
        cwd         => $temp_directory,
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [File["${download_dir}/${sanitised_title}_silent.rsp"],
                        Orawls::Utils::Orainst["create oraInst for ${name}"],
                        Exec["extract ${fmw_file1} for ${name}"],],
      }

      ## fix EditHttpConf in OHS Webgate
      if ( $version == 1112 and $fmw_product == 'webgate' ) {
        exec { "install ${sanitised_title} EditHttpConf1":
          command   => "unzip -o -j '${download_dir}/${sanitised_title}/Disk1/stage/Components/oracle.as.oam.webgate.ohs_linux64/11.1.2.2.0/1/DataFiles/filegroup1.jar' 'webgate/ohs/lib/libxmlengine.so' -d '${oracleHome}/webgate/ohs/lib/'",
          timeout   => 0,
          path      => $exec_path,
          user      => $os_user,
          group     => $os_group,
          logoutput => $log_output,
          cwd       => $temp_directory,
          require   => Exec["install ${sanitised_title}"],
        }
        exec { "install ${sanitised_title} EditHttpConf2":
          command   => "unzip -o -j '${download_dir}/${sanitised_title}/Disk1/stage/Components/oracle.as.oam.webgate.ohs_linux64/11.1.2.2.0/1/DataFiles/filegroup1.jar' 'webgate/ohs/lib/webgate.so' -d '${oracleHome}/webgate/ohs/lib/'",
          timeout   => 0,
          path      => $exec_path,
          user      => $os_user,
          group     => $os_group,
          logoutput => $log_output,
          cwd       => $temp_directory,
          require   => Exec["install ${sanitised_title}"],
        }
        exec { "install ${sanitised_title} EditHttpConf3":
          command   => "unzip -o -j '${download_dir}/${sanitised_title}/Disk1/stage/Components/oracle.as.oam.webgate.ohs_linux64/11.1.2.2.0/1/DataFiles/filegroup1.jar' 'webgate/ohs/tools/setup/InstallTools/EditHttpConf' -d '${oracleHome}/webgate/ohs/tools/setup/InstallTools/'",
          timeout   => 0,
          path      => $exec_path,
          user      => $os_user,
          group     => $os_group,
          logoutput => $log_output,
          cwd       => $temp_directory,
          require   => Exec["install ${sanitised_title}"],
        }
        file { "${oracleHome}/webgate/ohs/tools/setup/InstallTools/EditHttpConf":
          ensure  => file,
          mode    => '0775',
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          require => Exec["install ${sanitised_title} EditHttpConf3"],
        }
      }
    }
  }
}
