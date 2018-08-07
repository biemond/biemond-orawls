#
# opatch define
#
# installs oracle patches for Oracle products
#
# @param ensure should exist or not
# @param jdk_home_dir full path to the java home directory like /usr/java/default
# @param os_user the user name with oracle as default
# @param os_group the group name with dba as default
# @param log_output show all the output of the the exec actions
# @param download_dir the directory for temporary created files by this class
# @param oracle_product_home_dir on what Oracle home to patch should be applied
# @param patch_id id of the patch
# @param patch_file only the full name of the patch
# @param puppet_download_mnt_point the source of the installation files
# @param orainstpath_dir the location of orainst.loc, default it will the default directory for Linux or Solaris
# @param remote_file to control if the filename is already accessiable on the VM 
#
define orawls::opatchupgrade(
  String $oracle_product_home_dir   = undef, # /opt/oracle/middleware11gR1
  String $jdk_home_dir              = $::orawls::weblogic::jdk_home_dir,
  Integer $patch_id                 = undef,
  String $patch_file                = undef,
  String $opversion                 = undef,
  String $os_user                   = $::orawls::weblogic::os_user,
  String $os_group                  = $::orawls::weblogic::os_group,
  String $download_dir              = $::orawls::weblogic::download_dir,
  String $puppet_download_mnt_point = $::orawls::weblogic::puppet_download_mnt_point,
  Boolean $remote_file              = $::orawls::weblogic::remote_file,
  Boolean $log_output               = $::orawls::weblogic::log_output,
  Optional[String] $orainstpath_dir = $::orawls::weblogic::orainstpath_dir,
  String $java_parameters             = '',    # '-Dspace.detection=false'
)
{
  $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"
  $patch_dir = "${oracle_product_home_dir}/OPatch"

  # check the opatch version
  $installed_version = orawls::opatch_version($oracle_product_home_dir)

  if $installed_version == $opversion {
    $continue = false
  } else {
    notify {"orawls::opatchupgrade ${title} ${installed_version} installed - performing upgrade":}
    $continue = true
  }

  if ( $continue ) {
    if $remote_file == true {
      if ! defined(File["${download_dir}/${patch_file}"]) {
        file { "${download_dir}/${patch_file}":
          ensure => file,
          source => "${puppet_download_mnt_point}/${patch_file}",
          backup => false,
          mode   => '0775',
          owner  => $os_user,
          group  => $os_group,
        }
      }
      $disk1_file = "${download_dir}/${patch_file}"
    } else {
      $disk1_file = "${puppet_download_mnt_point}/${patch_file}"
    }

    $opatch_dir = "${download_dir}/wls_opatch"
    $opatch_jar_file = "${opatch_dir}/${patch_id}/opatch_generic.jar"

    # $disk1_file:      e.g. /u01/tmp/install/p28186730_139400_Generic.zip
    # $opatch_dir:      e.g. /u01/tmp/install/wls_opatch
    # $opatch_jar_file: e.g. /u01/tmp/install/wls_opatch/6880880/opatch_generic.jar

    exec { "extract opatch upgrade ${title} ${patch_file}":
      command   => "unzip -o ${disk1_file} -d ${opatch_dir}",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
      require   => [File[$disk1_file]],
    }

    $java_statement = "${lookup('orawls::java')} ${java_parameters}"
    $command        = "${java_statement} -jar ${opatch_jar_file} -silent oracle_home=${oracle_product_home_dir}"

    exec { "install opatch upgrade ${title}":
      command     => $command,
      environment => ['JAVA_VENDOR=Sun', "JAVA_HOME=${jdk_home_dir}"],
      timeout     => 0,
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      require     => [File[$opatch_jar_file]],
    }
  }
}
