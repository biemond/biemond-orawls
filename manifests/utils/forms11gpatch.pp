#
# utils::forms11gpatch define
#
# installs FMW 11g forms patch
#
# @param middleware_home_dir directory of the Oracle software inside the oracle base directory, will be default derived from the weblogic class
# @param weblogic_home_dir directory of the WebLogic software inside the middleware directory, will be default derived from the weblogic class
# @param jdk_home_dir full path to the java home directory like /usr/java/default, will be default derived from the weblogic class
# @param os_user the user name with oracle as default, will be default derived from the weblogic class
# @param os_group the group name with dba as default, will be default derived from the weblogic class
# @param log_output show all the output of the the exec actions, will be default derived from the weblogic class
# @param download_dir the directory for temporary created files by this class, will be default derived from the weblogic class
#
define orawls::utils::forms11gpatch (
  Integer $version                                        = $::orawls::weblogic::version,
  String $weblogic_home_dir                               = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir,
  String $jdk_home_dir                                    = $::orawls::weblogic::jdk_home_dir,
  String $oracle_base_home_dir                            = undef,
  Optional[String] $oracle_home_dir                       = undef, # /opt/oracle/middleware/Oracle_FRM1
  String $fmw_file1                                       = undef,
  String $puppet_download_mnt_point                       = $::orawls::weblogic::puppet_download_mnt_point,
  Boolean $remote_file                                    = $::orawls::weblogic::remote_file,
  String $temp_dir                                        = lookup('orawls::tmp_dir'),
  String $os_user                                         = $::orawls::weblogic::os_user,
  String $os_group                                        = $::orawls::weblogic::os_group,
  String $download_dir                                    = $::orawls::weblogic::download_dir,
  Boolean $log_output                                     = $::orawls::weblogic::log_output,
)
{
  $fmw_product  = 'forms_patch'
  $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"
  $oraInventory = "${oracle_base_home_dir}/oraInventory"

  case $facts['kernel'] {
    'Linux': {
      $oraInstPath = '/etc'
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
      $oraInstPath = '/var/opt/oracle'
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
      fail("Unrecognized operating system ${facts['kernel']}, please use it on a Linux host")
    }

  }

  $fmw_silent_response_file = 'orawls/fmw_silent_forms_patch.rsp.erb'
  if ($oracle_home_dir == undef) {
    $oracleHome = "${middleware_home_dir}/Oracle_FRM1"
  }
  else {
    $oracleHome = $oracle_home_dir
  }

  $createFile1 = "${download_dir}/${fmw_product}/Disk1"
  $total_files = 1


  if (1 == 1 ) {

    file { "${download_dir}/${title}_silent_${fmw_product}.rsp":
      ensure  => present,
      content => template($fmw_silent_response_file),
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
    }

    # for performance reasons, download and extract or just extract it
    if $remote_file == true {
      file { "${download_dir}/${fmw_file1}":
        ensure => file,
        source => "${puppet_download_mnt_point}/${fmw_file1}",
        mode   => '0775',
        owner  => $os_user,
        group  => $os_group,
        backup => false,
        before => Exec["extract ${fmw_file1}"],
      }
      $disk1_file = "${download_dir}/${fmw_file1}"
    } else {
      $disk1_file = "${puppet_download_mnt_point}/${fmw_file1}"
    }

    exec { "extract ${fmw_file1}":
      command   => "unzip -o ${disk1_file} -d ${download_dir}/${fmw_product}",
      creates   => $createFile1,
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => false,
    }

    $command = "-silent -response ${download_dir}/${title}_silent_${fmw_product}.rsp -waitforcompletion"

    exec { "install ${fmw_product} ${title}":
      command     => "/bin/sh -c 'unset DISPLAY;${download_dir}/${fmw_product}/Disk1/install/${installDir}/runInstaller ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs -jreLoc ${jdk_home_dir} -Djava.io.tmpdir=${temp_directory}'",
      environment => "TEMP=${temp_dir}",
      timeout     => 0,
      # creates     => "${oracleHome}/OPatch",
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      logoutput   => $log_output,
      require     => [File["${download_dir}/${title}_silent_${fmw_product}.rsp"],
                      Exec["extract ${fmw_file1}"],],
    }
  }
}
