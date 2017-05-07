# 
# weblogic installation define
#
# Will allow to install multiple WebLogic Middleware homes on a VM
#
# @example Declaring the define
#   orawls::weblogic_type{'12212':
#     version                   => 12212,
#     filename                  => 'fmw_12.2.1.2.0_wls.jar',
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
# @param version Weblogic version like 1036, 1111, 1213 or 12212
# @param filename the weblogic jar file like wls1036_generic.jar or fmw_12.2.1.2.0_wls.jar
# @param oracle_base_home_dir base directory of the oracle installation, it will contain the default Oracle inventory and the middleware home
# @param middleware_home_dir directory of the Oracle software inside the oracle base directory
# @param weblogic_home_dir directory of the WebLogic software inside the middleware directory
# @param wls_domains_dir root directory for all the WebLogic domains
# @param wls_apps_dir root directory for all the domain apps
# @param fmw_infra should install the WebLogic 12c infrastructure edition, you cannot use the normal wls install jar
# @param jdk_home_dir full path to the java home directory like /usr/java/default
# @param os_user the user name with oracle as default
# @param os_group the group name with dba as default
# @param download_dir the directory for temporary created by this class
# @param puppet_download_mnt_point the location of the filename like puppet:///modules/orawls/ or /software
# @param remote_file to control if the filename is already accessiable on the VM 
# @param java_parameters provide additional parameters to the WebLogic Installation
# @param log_output show all the output of the the exec actions
# @param temp_dir override the default temp directory /tmp
# @param validation ignore validation all the errrors
# @param force force the installation of WebLogic
# @param orainstpath_dir the location of orainst.loc, default it will the default directory for Linux or Solaris
#
define orawls::weblogic_type (
  Integer $version                    = lookup('orawls::default_version'),
  String $filename                    = undef, # wls1036_generic.jar|wls1211_generic.jar|wls_121200.jar|wls_121300.jar|oepe-wls-indigo-installer-11.1.1.8.0.201110211138-10.3.6-linux32.bin
  String $oracle_base_home_dir        = undef, # /opt/oracle
  String $middleware_home_dir         = undef, # /opt/oracle/middleware11gR1
  Optional[String] $weblogic_home_dir = undef, # /opt/oracle/middleware11gR1/wlserver
  Optional[String] $wls_domains_dir   = undef, # /opt/oracle/wlsdomains/domains
  Optional[String] $wls_apps_dir      = undef, # /opt/oracle/wlsdomains/applications
  Boolean $fmw_infra                  = false, # true|false 1212/1213/1221 option -> plain weblogic or fmw infra
  String $jdk_home_dir                = undef, # /usr/java/jdk1.7.0_45
  String $os_user                     = lookup('orawls::user'), # oracle
  String $os_group                    = lookup('orawls::group'), # dba
  String $download_dir                = lookup('orawls::download_dir'),
  String $puppet_download_mnt_point   = lookup('orawls::module_mountpoint'), # puppet:///modules/orawls/ | /mnt | /vagrant
  Boolean $remote_file                = true,  # true|false
  String $java_parameters             = '',    # '-Dspace.detection=false'
  Boolean $log_output                 = false, # true|false
  Boolean $validation                 = true,  # true|false
  Boolean $force                      = false, # true|false
  String $temp_dir                    = lookup('orawls::tmp_dir'),# /tmp temporary directory for files extractions
  Optional[String] $orainstpath_dir   = lookup('orawls::orainst_dir'),
)
{

  if ( $wls_domains_dir != undef) {
    # make sure you don't create the middleware home, else root will be owner
    if ($wls_domains_dir == "${middleware_home_dir}/user_projects/domains") {
        $domains_dir =  undef
    } else {
        $domains_dir =  $wls_domains_dir
    }
  } else {
    $domains_dir =  undef
  }
  if ( $wls_apps_dir != undef) {
    # make sure you don't create the middleware home, else root will be owner
    if ($wls_apps_dir == "${middleware_home_dir}/user_projects/applications") {
        $apps_dir =  undef
    } else {
        $apps_dir =  $wls_apps_dir
    }
  } else {
    $apps_dir =  undef
  }

  if ($version == 1036 or $version == 1111 or $version == 1211) {
    $silent_template = 'orawls/weblogic_silent_install.xml.epp'
    $install_type = 'dummy'
  } elsif ( $version == 1212 or $version == 1213 or $version >= 1221 ) {

    #The oracle home location. This can be an existing Oracle Home or a new Oracle Home
    if ( $fmw_infra == true ) {
      $install_type = 'Fusion Middleware Infrastructure'
    } else {
      $install_type = 'WebLogic Server'
    }
    if $version >= 1221 {
      $new_version = 1221
    } else {
      $new_version = $version
    }
    $silent_template = "orawls/weblogic_silent_install_${new_version}.rsp.epp"

  } else  {
    fail('unknown weblogic version parameter')
  }

  $exec_path         = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"
  $ora_inventory_dir = "${oracle_base_home_dir}/oraInventory"

  Exec {
    logoutput => $log_output,
  }

  $java_statement = "${lookup('orawls::java')} ${java_parameters}"
  $file_ext = regsubst($filename, '.*(\.jar)$', '\1')

  if $file_ext == '.jar' {
    $jar_file = true
  } else {
    $jar_file = false
  }

  if $jar_file {
    $cmd_prefix = "${java_statement} -Xmx1024m -Djava.io.tmpdir=${temp_dir} -jar "
  } else {
    $cmd_prefix = ''
  }

  if $remote_file == true {
    $weblogic_jar_location = "${download_dir}/${filename}"
  } else {
    $weblogic_jar_location = "${puppet_download_mnt_point}/${filename}"
  }

  if $validation == false {
    $validation_string = '-novalidation'
  } else {
    $validation_string = ''
  }

  if $force == true {
    $force_string = '-force'
  } else {
    $force_string = ''
  }

  orawls::utils::orainst { "weblogic orainst ${title}":
    ora_inventory_dir => $ora_inventory_dir,
    os_group          => $os_group,
    orainstpath_dir   => $orainstpath_dir
  }

  wls_directory_structure{"weblogic structure ${title}":
    ensure            => present,
    oracle_base_dir   => $oracle_base_home_dir,
    ora_inventory_dir => $ora_inventory_dir,
    download_dir      => $download_dir,
    wls_domains_dir   => $domains_dir,
    wls_apps_dir      => $apps_dir,
    os_user           => $os_user,
    os_group          => $os_group,
    require           => Orawls::Utils::Orainst["weblogic orainst ${title}"],
  }

  # for performance reasons, download and install or just install it
  if $remote_file == true {
    # put weblogic generic jar
    if !defined(File["${download_dir}/${filename}"]) {
      file { "${download_dir}/${filename}":
        ensure  => file,
        source  => "${puppet_download_mnt_point}/${filename}",
        replace => false,
        backup  => false,
        mode    => lookup('orawls::permissions'),
        owner   => $os_user,
        group   => $os_group,
        before  => Exec["install weblogic ${title}"],
        require => Wls_directory_structure["weblogic structure ${title}"],
      }
    }
    # we need to make proper dependency even when File["${download_dir}/${filename}"] is already defined
    Wls_directory_structure["weblogic structure ${title}"] -> File["${download_dir}/${filename}"] -> Exec["install weblogic ${title}"]
  }

  # de xml used by the wls installer
  file { "${download_dir}/weblogic_silent_install_${title}.xml":
    ensure  => present,
    content => epp($silent_template, {
                    'middleware_home_dir' => $middleware_home_dir,
                    'weblogic_home_dir'   => $weblogic_home_dir,
                    'install_type'        => $install_type }),
    replace => true,
    mode    => lookup('orawls::permissions'),
    owner   => $os_user,
    group   => $os_group,
    backup  => false,
    require => Wls_directory_structure["weblogic structure ${title}"],
  }

  # if weblogic home dir is specified then check that for creates
  if ( $weblogic_home_dir != undef ) {
    $created_dir = $weblogic_home_dir
  } else {
    $created_dir = $middleware_home_dir
  }

  if ($version == 1212 or $version == 1213 or $version >= 1221 ) {

    $command = "-silent -responseFile ${download_dir}/weblogic_silent_install_${title}.xml ${validation_string} ${force_string} "

    # notify { "install weblogic ${version}: ${exec_path}": }
    exec { "install weblogic ${title}":
      command     => "${cmd_prefix}${weblogic_jar_location} ${command} -invPtrLoc ${orainstpath_dir}/oraInst.loc -ignoreSysPrereqs",
      environment => ['JAVA_VENDOR=Sun', "JAVA_HOME=${jdk_home_dir}"],
      timeout     => 0,
      creates     => $created_dir,
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      require     => [Wls_directory_structure["weblogic structure ${title}"],
                      Orawls::Utils::Orainst["weblogic orainst ${title}"],
                      File["${download_dir}/weblogic_silent_install_${title}.xml"]],
    }
    # OPatch native lib fix for 64 solaris
    if ( $facts['kernel'] == 'SunOS' ) {
      exec { "add -d64 oraparam.ini oracle_common ${title}":
        command => "sed -e's/JRE_MEMORY_OPTIONS=/JRE_MEMORY_OPTIONS=\"-d64\"/g' ${middleware_home_dir}/oui/oraparam.ini > ${temp_dir}/wls.tmp && mv ${temp_dir}/wls.tmp ${middleware_home_dir}/oui/oraparam.ini",
        unless  => "grep 'JRE_MEMORY_OPTIONS=\"-d64\"' ${middleware_home_dir}/oui/oraparam.ini",
        require => Exec["install weblogic ${title}"],
        path    => $exec_path,
        user    => $os_user,
        group   => $os_group,
      }
    }

  } else {
    exec {"install weblogic ${title}":
      command     => "${cmd_prefix}${weblogic_jar_location} -Djava.io.tmpdir=${temp_dir} -Duser.country=US -Duser.language=en -mode=silent ${validation_string} ${force_string} -log=${temp_dir}/wls_${title}.out -log_priority=info -silent_xml=${download_dir}/weblogic_silent_install_${title}.xml",
      environment => ['JAVA_VENDOR=Sun',"JAVA_HOME=${jdk_home_dir}"],
      creates     => $created_dir,
      timeout     => 0,
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      require     => [Wls_directory_structure["weblogic structure ${title}"],
                      File["${download_dir}/weblogic_silent_install_${title}.xml"]],
    }
  }
}
