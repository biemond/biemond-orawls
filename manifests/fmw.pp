#
# fmw define
#
# installs FMW software like ADF, FORMS, OIM, WC, WCC, OSB, SOA Suite, B2B, MFT
#
# @example installing FMW
#   orawls::fmw{'webtier1221':
#     fmw_product          => 'web',
#     fmw_file1            => "fmw_12.2.1.2.0_ohs_linux64_Disk1_1of1.zip",
#     oracle_base_home_dir => '/opt/oracle',
#   }
#
#   orawls::fmw{'soa1221':
#     fmw_product          => 'soa',
#     fmw_file1            => "fmw_12.2.1.2.0_soa_Disk1_1of1.zip",
#     oracle_base_home_dir => '/opt/oracle',
#   }
#
#   orawls::fmw{'osb1221':
#     fmw_product          => 'osb',
#     fmw_file1            => "fmw_12.2.1.2.0_osb_Disk1_1of1.zip",
#     oracle_base_home_dir => '/opt/oracle',
#   }
#
#   orawls::fmw{'webtier12212':
#     version                   => 12212,
#     fmw_product               => 'web',
#     fmw_file1                 => "fmw_12.2.1.2.0_ohs_linux64_Disk1_1of1.zip",
#     oracle_base_home_dir      => '/opt/oracle',
#     ohs_mode:                 =>  "standalone",
#     jdk_home_dir              => '/usr/java/latest',
#     oracle_base_home_dir      => "/opt/oracle",
#     middleware_home_dir       => "/opt/oracle/middleware12c",
#     weblogic_home_dir         => "/opt/oracle/middleware12c/wlserver",
#     download_dir              => "/var/tmp/install",
#     puppet_download_mnt_point => "/software",
#     log_output                => true,
#     remote_file               => false
#   }
#
# @param version used weblogic software like 1036
# @param middleware_home_dir directory of the Oracle software inside the oracle base directory
# @param weblogic_home_dir directory of the WebLogic software inside the middleware directory
# @param jdk_home_dir full path to the java home directory like /usr/java/default
# @param os_user the user name with oracle as default
# @param os_group the group name with dba as default
# @param log_output show all the output of the the exec actions
# @param download_dir the directory for temporary created files by this class
# @param oracle_base_home_dir base directory of the oracle installation, it will contain the default Oracle inventory and the middleware home
# @param fmw_product what to install
# @param fmw_file1 the fmw install file 1
# @param fmw_file2 the fmw install file 2
# @param fmw_file3 the fmw install file 3
# @param fmw_file4 the fmw install file 4
# @param bpm enable bpm on the soa suite install
# @param healthcare enable healthcare on the b2b install
# @param puppet_download_mnt_point the source of the installation files
# @param temp_dir override the default temp directory /tmp
# @param ohs_mode the install type of webtier
# @param wcs_mode the install type of webcenter sites
# @param oracle_inventory_dir define your own location of the Oracle inventory
# @param orainstpath_dir the location of orainst.loc, default it will the default directory for Linux or Solaris
# @param oracle_home_dir override what Oracle home should be inside the middleware home
# @param remote_file to control if the filename is already accessiable on the VM 
#
define orawls::fmw(
  Integer $version                                        = $::orawls::weblogic::version,
  String $weblogic_home_dir                               = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir,
  String $jdk_home_dir                                    = $::orawls::weblogic::jdk_home_dir,
  String $oracle_base_home_dir                            = undef, # /opt/oracle
  Optional[String] $oracle_home_dir                       = undef, # /opt/oracle/middleware/Oracle_SOA
  Enum['adf','soa','soaqs','osb','wcc','wc','wcs','oim','oam','ovd','web','webgate','oud','mft','b2b','forms'] $fmw_product = undef,
  String $fmw_file1                                       = undef,
  Optional[String] $fmw_file2                             = undef,
  Optional[String] $fmw_file3                             = undef,
  Optional[String] $fmw_file4                             = undef,
  Boolean $bpm                                            = false,
  Boolean $healthcare                                     = false,
  String $os_user                                         = $::orawls::weblogic::os_user,
  String $os_group                                        = $::orawls::weblogic::os_group,
  String $download_dir                                    = $::orawls::weblogic::download_dir,
  Boolean $log_output                                     = $::orawls::weblogic::log_output,
  String $puppet_download_mnt_point                       = $::orawls::weblogic::puppet_download_mnt_point,
  String $temp_dir                                        = lookup('orawls::tmp_dir'),# /tmp temporary directory for files extractions
  Optional[String] $ohs_mode                              = 'collocated',
  Enum['sites','examples','satellite'] $wcs_mode          = 'sites',
  Optional[String] $oracle_inventory_dir                  = undef,
  Boolean $remote_file                                    = $::orawls::weblogic::remote_file,
  Optional[String] $orainstpath_dir                       = lookup('orawls::orainst_dir'),
  Boolean $cleanup_install_files                          = true,
)
{

  $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

  if $oracle_inventory_dir == undef {
    $oraInventory = "${oracle_base_home_dir}/oraInventory"
  } else {
    $oraInventory = $oracle_inventory_dir
  }

  case $facts['kernel'] {
    'Linux': {
      case $facts['architecture'] {
        'i386': {
          $installDir = 'linux'
        }
        default: {
          $installDir = 'linux64'
        }
      }
    }
    'SunOS': {
      case $facts['architecture'] {
        'i86pc': {
          $installDir = 'intelsolaris'
        }
        default: {
          $installDir = 'solaris'
        }
      }
    }
    default: {
      fail("Unrecognized operating system ${facts['kernel']}, please use it on a Linux, Solaris host")
    }

  }
  #Sanitise the resource title so that it can safely be used in filenames and execs etc.
  #After converting all spaces to underscores, remove all non alphanumeric characters (allow hypens and underscores too)
  $convert_spaces_to_underscores = regsubst($title,'\s','_','G')
  $sanitised_title = regsubst ($convert_spaces_to_underscores,'[^a-zA-Z0-9_-]','','G')

  if ( $fmw_product == 'adf' ) {
    $fmw_silent_response_file = 'orawls/fmw_silent_adf.rsp.epp'
    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/oracle_common"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
    $total_files = 1
    $install_type = 'dummy'
  } elsif ( $fmw_product == 'forms' ) {

    if $version >= 1221 {
      $fmw_silent_response_file = 'orawls/fmw_silent_forms_1221.rsp.epp'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_fr_linux64.bin'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_fr_linux64.bin'
      } elsif $version == 12212 {
        $binFile1                 = 'fmw_12.2.1.2.0_fr_linux64.bin'
      } else {
        $binFile1                 = 'fmw_12.2.1.3.0_fr_linux64.bin'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'bin'
      $total_files              = 1
      $install_type             = 'Forms and Reports Deployment'
      $oracleHome               = "${middleware_home_dir}/forms"
    }
    else {
      $fmw_silent_response_file = 'orawls/fmw_silent_forms.rsp.epp'
      $install_type = 'dummy'
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
      $fmw_silent_response_file = 'orawls/fmw_silent_soa_1221.rsp.epp'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_soa.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_soa.jar'
      } elsif $version == 12212 {
        $binFile1                 = 'fmw_12.2.1.2.0_soa.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.3.0_soa.jar'
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
      $fmw_silent_response_file = 'orawls/fmw_silent_soa_1213.rsp.epp'
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
      $fmw_silent_response_file = 'orawls/fmw_silent_soa.rsp.epp'
      $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
      $createFile2 = "${download_dir}/${sanitised_title}/Disk4"
      $install_type = 'dummy'
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
      $fmw_silent_response_file = 'orawls/fmw_silent_soa_1221.rsp.epp'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_soa_quickstart.jar'
        $binFile2                 = 'fmw_12.2.1.0.0_soa_quickstart2.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_soa_quickstart.jar'
        $binFile2                 = 'fmw_12.2.1.1.0_soa_quickstart2.jar'
      } elsif $version == 12212 {
        $binFile1                 = 'fmw_12.2.1.2.0_soa_quickstart.jar'
        $binFile2                 = 'fmw_12.2.1.2.0_soa_quickstart2.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.3.0_soa_quickstart.jar'
        $binFile2                 = 'fmw_12.2.1.3.0_soa_quickstart2.jar'
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
      $fmw_silent_response_file = 'orawls/fmw_silent_soa_1213.rsp.epp'
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
      $fmw_silent_response_file = 'orawls/fmw_silent_osb_1221.rsp.epp'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_osb.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_osb.jar'
      } elsif $version == 12212 {
        $binFile1                 = 'fmw_12.2.1.2.0_osb.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.3.0_osb.jar'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/osb/bin"
      $type                     = 'java'
      $install_type             = 'Service Bus'
    }
    elsif $version == 1213 {
      $fmw_silent_response_file = 'orawls/fmw_silent_osb_1213.rsp.epp'
      $binFile1                 = 'fmw_12.1.3.0.0_osb.jar'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/osb/bin"
      $type                     = 'java'
      $install_type             = 'Service Bus'
    }
    else {
      $fmw_silent_response_file = 'orawls/fmw_silent_osb.rsp.epp'
      $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
      $install_type = 'Service Bus'
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
      $fmw_silent_response_file = 'orawls/fmw_silent_b2b_1213.rsp.epp'
      $binFile1                 = 'fmw_12.1.3.0.0_b2bhealthcare.jar'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/soa/soa/modules/oracle.soa.b2b_11.1.1/b2b.jar"
      $type                     = 'java'
    }
    elsif $version >= 1221 {
      $total_files = 1
      $fmw_silent_response_file = 'orawls/fmw_silent_b2b_1221.rsp.epp'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_b2bhealthcare.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_b2bhealthcare.jar'
      } elsif $version == 12212 {
        $binFile1                 = 'fmw_12.2.1.2.0_b2bhealthcare.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.3.0_b2bhealthcare.jar'
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
      $fmw_silent_response_file = 'orawls/fmw_silent_mft_1213.rsp.epp'
      $binFile1                 = 'fmw_12.1.3.0.0_mft.jar'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $oracleHome               = "${middleware_home_dir}/mft/bin"
      $type                     = 'java'
      $install_type             = 'dummy'
    } else {
      fail('Unrecognized version for mft')
    }

  } elsif ( ( $fmw_product == 'oim' ) or ( $fmw_product == 'oam' ) ) {

    if $version >= 1221 {
      $fmw_silent_response_file = 'orawls/fmw_silent_oim_1221.rsp.epp'
      $install_type             = 'Collocated Oracle Identity and Access Manager (Managed through WebLogic server)'
      $binFile1                 = 'fmw_12.2.1.3.0_idm.jar'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'java'

      $total_files = 1

      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/idm"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
    } else {
      $fmw_silent_response_file = 'orawls/fmw_silent_oim.rsp.epp'
      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/Oracle_IDM1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
      $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
      $createFile2 = "${download_dir}/${sanitised_title}/Disk2"
      $createFile3 = "${download_dir}/${sanitised_title}/Disk3"
      $total_files = 3
      $install_type = 'dummy'
    }

  } elsif ( $fmw_product == 'ovd' ) {

    $fmw_silent_response_file = 'orawls/fmw_silent_ovd.rsp.epp'
    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/Oracle_IDM1"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
    $createFile2 = "${download_dir}/${sanitised_title}/Disk5"

    $total_files = 2
    $install_type = 'dummy'

  } elsif ( $fmw_product == 'wc' ) {

    if $version >= 1221 {
      $fmw_silent_response_file = 'orawls/fmw_silent_wc_1221.rsp.epp'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_wcportal_generic.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_wcportal_generic.jar'
      } elsif $version == 12212 {
        $binFile1                 = 'fmw_12.2.1.2.0_wcportal_generic.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.3.0_wcportal_generic.jar'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'java'
      $total_files              = 1
      $oracleHome               = "${middleware_home_dir}/wcportal"
      $install_type             = 'WebCenter Portal'
    }
    else {
      $fmw_silent_response_file = 'orawls/fmw_silent_wc.rsp.epp'
      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/Oracle_WC1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
      $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
      $total_files = 1
      $install_type = 'dummy'
    }

  } elsif ( $fmw_product == 'wcc' ) {

    if $version >= 1221 {
      $fmw_silent_response_file = 'orawls/fmw_silent_wcc_1221.rsp.epp'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_wccontent_generic.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_wccontent_generic.jar'
      } elsif $version == 12212 {
        $binFile1                 = 'fmw_12.2.1.2.0_wccontent_generic.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.3.0_wccontent_generic.jar'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'java'
      $total_files              = 1
      $oracleHome               = "${middleware_home_dir}/wccontent"
      $install_type             = 'dummy'
    }
    else {
      $fmw_silent_response_file = 'orawls/fmw_silent_wcc.rsp.epp'
      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/Oracle_WCC1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }
      $createFile1 = "${download_dir}/${sanitised_title}/Disk1"
      $createFile2 = "${download_dir}/${sanitised_title}/Disk2"
      $total_files = 2
      $install_type = 'dummy'
    }

} elsif ( $fmw_product == 'wcs' ) {

    if ($wcs_mode == 'sites') {
      $install_type = 'WebCenter Sites'
    } elsif ($wcs_mode == 'examples') {
      $install_type = 'WebCenter Sites - With Examples'
    } elsif ($wcs_mode == 'satelite') {
      $install_type = 'WebCenter Sites - Satellite Server'
    } else {
      fail("Unrecognized parameter wcs_mode: ${wcs_mode}, please use sites|examples|satellite")
    }

    if $version >= 1221 {
      $fmw_silent_response_file = 'orawls/fmw_silent_wcs_1221.rsp.epp'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_wcsites_generic.jar'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_wcsites.jar'
      } elsif $version == 12212 {
        $binFile1                 = 'fmw_12.2.1.2.0_wcsites.jar'
      } elsif $version == 12214 {
        $binFile1                 = 'fmw_12.2.1.4.0_wcsites.jar'
      } else {
        $binFile1                 = 'fmw_12.2.1.3.0_wcsites.jar'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'java'
      $total_files              = 1
      $oracleHome               = "${middleware_home_dir}/wcsites"
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
      $fmw_silent_response_file = 'orawls/web_http_server_1212.rsp.epp'
      $binFile1                 = 'ohs_121200_linux64.bin'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'bin'
    }
    elsif $version == 1213 {
      $fmw_silent_response_file = 'orawls/web_http_server_1213.rsp.epp'
      $binFile1                 = 'fmw_12.1.3.0.0_ohs_linux64.bin'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'bin'
    }
    elsif $version >= 1221 {
      $fmw_silent_response_file = 'orawls/web_http_server_1221.rsp.epp'
      if $version == 1221 {
        $binFile1                 = 'fmw_12.2.1.0.0_ohs_linux64.bin'
      } elsif $version == 12211 {
        $binFile1                 = 'fmw_12.2.1.1.0_ohs_linux64.bin'
      } elsif $version == 12212 {
        $binFile1                 = 'fmw_12.2.1.2.0_ohs_linux64.bin'
      } elsif $version == 12214 {
        $binFile1                 = 'fmw_12.2.1.4.0_ohs_linux64.bin'
      } else {
        $binFile1                 = 'fmw_12.2.1.3.0_ohs_linux64.bin'
      }
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'bin'
    }
    else {
      $fmw_silent_response_file = 'orawls/web_http_server.rsp.epp'
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

    $fmw_silent_response_file = 'orawls/fmw_webgate.rsp.epp'
    $createFile1              = "${download_dir}/${sanitised_title}/Disk1"
    $install_type             = 'dummy'

    if ($oracle_home_dir == undef) {
      $oracleHome = "${middleware_home_dir}/Oracle_OAMWebGate1"
    }
    else {
      $oracleHome = $oracle_home_dir
    }
    $total_files = 1

  } elsif ( $fmw_product == 'oud' ) {

    if $version == 1221 {
      $fmw_silent_response_file = 'orawls/fmw_silent_oud_1221.rsp.epp'
      $install_type             = 'Collocated Oracle Unified Directory Server (Managed through WebLogic server)'
      $binFile1                 = 'fmw_12.2.1.3.0_oud.jar'
      $createFile1              = "${download_dir}/${sanitised_title}/${binFile1}"
      $type                     = 'java'

      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/oud"
      }
      else {
        $oracleHome = $oracle_home_dir
      }

    } else {
      $fmw_silent_response_file = 'orawls/fmw_silent_oud.rsp.epp'
      $createFile1              = "${download_dir}/${sanitised_title}/Disk1"
      $install_type             = 'dummy'

      if ($oracle_home_dir == undef) {
        $oracleHome = "${middleware_home_dir}/Oracle_OUD1"
      }
      else {
        $oracleHome = $oracle_home_dir
      }

    }

    $total_files = 1

  } else {
    fail('unknown fmw_product value choose adf|soa|soaqs|osb|oim|oam|wc|wcc|web|webgate|oud')
  }

  # check if the oracle product already exists, only for < 12.1.2, this is for performance reasons
  if $version == 1212 or $version == 1213 or $version >= 1221 {
    $continue = true
  } else {
    $found = orawls::fmw_exists($oracleHome)

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

    orawls::utils::orainst { "create oraInst for ${name}":
      ora_inventory_dir => $oraInventory,
      os_group          => $os_group,
      orainstpath_dir   => $orainstpath_dir
    }

    file { "${download_dir}/${sanitised_title}_silent.rsp":
      ensure  => present,
      content => epp($fmw_silent_response_file, {
                      'middleware_home_dir' => $middleware_home_dir,
                      'oracleHome'          => $oracleHome,
                      'install_type'        => $install_type,
                      'weblogic_home_dir'   => $weblogic_home_dir }),
      mode    => lookup('orawls::permissions'),
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
      require => Orawls::Utils::Orainst["create oraInst for ${name}"],
    }

    # for performance reasons, download and extract or just extract it
    if $remote_file == true {
      file { "${download_dir}/${fmw_file1}":
        ensure => file,
        source => "${puppet_download_mnt_point}/${fmw_file1}",
        mode   => lookup('orawls::permissions'),
        owner  => $os_user,
        group  => $os_group,
        backup => false,
        before => Exec["extract ${fmw_file1} for ${name}"],
      }
      $disk1_file = "${download_dir}/${fmw_file1}"
    } else {
      $disk1_file = "${puppet_download_mnt_point}/${fmw_file1}"
    }

    exec { "extract ${fmw_file1} for ${name}":
      command   => "unzip -o ${disk1_file} -d ${download_dir}/${sanitised_title}",
      creates   => $createFile1,
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      timeout   => 0,
      cwd       => $temp_dir,
      logoutput => false,
      require   => Orawls::Utils::Orainst["create oraInst for ${name}"],
    }

    # TODO: we should make a utility function to handle each file rather than copy/pasting and editing
    if ( $total_files > 1 ) {

      # for performance reasons, download and extract or just extract it
      if $remote_file == true {

        file { "${download_dir}/${fmw_file2}":
          ensure  => file,
          source  => "${puppet_download_mnt_point}/${fmw_file2}",
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          before  => Exec["extract ${fmw_file2} for ${name}"],
          require => [File["${download_dir}/${fmw_file1}"],
                      Exec["extract ${fmw_file1} for ${name}"],],
        }
        $disk2_file = "${download_dir}/${fmw_file2}"
      } else {
        $disk2_file = "${puppet_download_mnt_point}/${fmw_file2}"
      }

      exec { "extract ${fmw_file2} for ${name}":
        command   => "unzip -o ${disk2_file} -d ${download_dir}/${sanitised_title}",
        creates   => $createFile2,
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        timeout   => 0,
        cwd       => $temp_dir,
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
          source  => "${puppet_download_mnt_point}/${fmw_file3}",
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          before  => Exec["extract ${fmw_file3}"],
          require => [File["${download_dir}/${fmw_file2}"],
                      Exec["extract ${fmw_file2}"],],
        }
        $disk3_file = "${download_dir}/${fmw_file3}"
      } else {
        $disk3_file = "${puppet_download_mnt_point}/${fmw_file3}"
      }

      exec { "extract ${fmw_file3} for ${name}":
        command   => "unzip -o ${disk3_file} -d ${download_dir}/${sanitised_title}",
        creates   => $createFile3,
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        timeout   => 0,
        cwd       => $temp_dir,
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
          source  => "${puppet_download_mnt_point}/${fmw_file4}",
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          before  => Exec["extract ${fmw_file4}"],
          require => [File["${download_dir}/${fmw_file3}"],
                      Exec["extract ${fmw_file3} for ${name}"],],
        }
        $disk4_file = "${download_dir}/${fmw_file4}"
      } else {
        $disk4_file = "${puppet_download_mnt_point}/${fmw_file4}"
      }

      exec { "extract ${fmw_file4} for ${name}":
        command   => "unzip -o ${disk4_file} -d ${download_dir}/${sanitised_title}",
        creates   => $createFile4,
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        timeout   => 0,
        cwd       => $temp_dir,
        logoutput => false,
        require   => Exec["extract ${fmw_file3} for ${name}"],
        before    => Exec["install ${sanitised_title}"],
      }
    }

    if $facts['kernel'] == 'SunOS' {
      if $version < 1213 {
        if $fmw_product == 'soa' {
          exec { "add -d64 oraparam.ini ${sanitised_title}":
            command   => "sed -e's/JRE_MEMORY_OPTIONS=\" -Xverify:none\"/JRE_MEMORY_OPTIONS=\"-d64 -Xverify:none\"/g' ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini > ${temp_dir}/soa.tmp && mv ${temp_dir}/soa.tmp ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini",
            unless    => "grep 'JRE_MEMORY_OPTIONS=\"-d64' ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini",
            require   => Exec["extract ${fmw_file1} for ${name}","extract ${fmw_file2} for ${name}"],
            before    => Exec["install ${sanitised_title}"],
            path      => $exec_path,
            user      => $os_user,
            group     => $os_group,
            cwd       => $temp_dir,
            logoutput => $log_output,
          }
        }
        if $fmw_product == 'osb' {
          exec { "add -d64 oraparam.ini ${sanitised_title}":
            command   => "sed -e's/\\[Oracle\\]/\\[Oracle\\]\\\nJRE_MEMORY_OPTIONS=\"-d64\"/g' ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini > ${temp_dir}/osb.tmp && mv ${temp_dir}/osb.tmp ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini",
            unless    => "grep 'JRE_MEMORY_OPTIONS=\"-d64\"' ${download_dir}/${sanitised_title}/Disk1/install/${installDir}/oraparam.ini",
            require   => Exec["extract ${fmw_file1} for ${name}"],
            before    => Exec["install ${sanitised_title}"],
            path      => $exec_path,
            user      => $os_user,
            group     => $os_group,
            cwd       => $temp_dir,
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

    if ($version == 1212 or $version == 1213 or $version >= 1221) {
      if $type == 'java' {
        $install = "java -Djava.io.tmpdir=${temp_dir} -jar "
      }
      else {
        $install = ''
      }

      exec { "install ${sanitised_title}":
        command     => "${install}${download_dir}/${sanitised_title}/${binFile1} ${command} -invPtrLoc ${orainstpath_dir}/oraInst.loc -ignoreSysPrereqs -jreLoc ${jdk_home_dir}",
        environment => "TEMP=${temp_dir}",
        timeout     => 0,
        creates     => $oracleHome,
        cwd         => $temp_dir,
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
        command     => "/bin/sh -c 'unset DISPLAY;${download_dir}/${sanitised_title}/Disk1/install/${installDir}/runInstaller ${command} -invPtrLoc ${orainstpath_dir}/oraInst.loc -ignoreSysPrereqs -jreLoc ${jdk_home_dir} -Djava.io.tmpdir=${temp_dir}'",
        environment => "TEMP=${temp_dir}",
        timeout     => 0,
        creates     => "${oracleHome}/OPatch",
        cwd         => $temp_dir,
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [File["${download_dir}/${sanitised_title}_silent.rsp"],
                        Orawls::Utils::Orainst["create oraInst for ${name}"],
                        Exec["extract ${fmw_file1} for ${name}"],],
      }
    }

    # cleanup
    if ( $cleanup_install_files ) {
      exec { "remove extract folder ${title}":
        command => "rm -rf ${download_dir}/${sanitised_title}",
        user    => 'root',
        group   => 'root',
        path    => $exec_path,
        cwd     => $temp_dir,
        require => Exec["install ${sanitised_title}"],
        }
      if ( $remote_file == true ){
        exec { "remove ${fmw_file1} ${title}":
          command => "rm -rf ${download_dir}/${fmw_file1}",
          user    => 'root',
          group   => 'root',
          path    => $exec_path,
          cwd     => $temp_dir,
          require => Exec["install ${sanitised_title}"],
        }
        if ( $total_files > 1 ) {
          exec { "remove ${fmw_file2} ${title}":
            command => "rm -rf ${download_dir}/${fmw_file2}",
            user    => 'root',
            group   => 'root',
            path    => $exec_path,
            cwd     => $temp_dir,
            require => Exec["install ${sanitised_title}"],
          }
        }
        if ( $total_files > 2 ) {
          exec { "remove ${fmw_file3} ${title}":
            command => "rm -rf ${download_dir}/${fmw_file3}",
            user    => 'root',
            group   => 'root',
            path    => $exec_path,
            cwd     => $temp_dir,
            require => Exec["install ${sanitised_title}"],
          }
        }
      }
    }
  }
}
