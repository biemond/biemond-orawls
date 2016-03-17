# == Define: orawls::utils::forms11gpatch
#
# installs FMW 11g forms patch
#
##
define orawls::utils::forms11gpatch (
  $oracle_home_dir      = undef,                                      # /opt/oracle/middleware/Oracle_FRM1
  $fmw_file1            = undef,
  $remote_file          = true,                                       # true|false
)
{
  $version              = $::orawls::weblogic::version
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

  $fmw_product  = 'forms_patch'

  $exec_path    = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"
  $oraInventory = "${oracle_base_home_dir}/oraInventory"

  case $::kernel {
    'Linux': {
      $oraInstPath = '/etc'
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

    if $source == undef {
      $mountPoint = 'puppet:///modules/orawls/'
    } else {
      $mountPoint = $source
    }

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
        source => "${mountPoint}/${fmw_file1}",
        mode   => '0775',
        owner  => $os_user,
        group  => $os_group,
        backup => false,
        before => Exec["extract ${fmw_file1}"],
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
    }

    $command = "-silent -response ${download_dir}/${title}_silent_${fmw_product}.rsp -waitforcompletion"

    exec { "install ${fmw_product} ${title}":
      command     => "/bin/sh -c 'unset DISPLAY;${download_dir}/${fmw_product}/Disk1/install/${installDir}/runInstaller ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs -jreLoc ${jdk_home_dir} -Djava.io.tmpdir=${temp_directory}'",
      environment => "TEMP=${temp_directory}",
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
