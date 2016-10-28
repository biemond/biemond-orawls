# rewrite of Class: orawls::weblogic as defined type so multiple installation of product will be possible on single host
#
define orawls::weblogic_type (
  $version              = 1111,  # 1036|1111|1211|1212|1213|1221|12211|12212
  $filename             = undef, # wls1036_generic.jar|wls1211_generic.jar|wls_121200.jar|wls_121300.jar|oepe-wls-indigo-installer-11.1.1.8.0.201110211138-10.3.6-linux32.bin
  $oracle_base_home_dir = undef, # /opt/oracle
  $middleware_home_dir  = undef, # /opt/oracle/middleware11gR1
  $weblogic_home_dir    = undef, # /opt/oracle/middleware11gR1/wlserver
  $wls_domains_dir      = undef, # /opt/oracle/wlsdomains/domains
  $wls_apps_dir         = undef, # /opt/oracle/wlsdomains/applications
  $fmw_infra            = false, # true|false 1212/1213/1221 option -> plain weblogic or fmw infra
  $jdk_home_dir         = undef, # /usr/java/jdk1.7.0_45
  $os_user              = undef, # oracle
  $os_group             = undef, # dba
  $download_dir         = undef, # /data/install
  $source               = undef, # puppet:///modules/orawls/ | /mnt | /vagrant
  $remote_file          = true,  # true|false
  $java_parameters      = '',    # '-Dspace.detection=false'
  $log_output           = false, # true|false
  $validation           = true,  # true|false
  $force                = false, # true|false
  $temp_directory       = '/tmp',# /tmp temporay directory for files extractions
  $orainstpath_dir      = hiera('orainstpath_dir', undef),
) {

  # check required parameters
  if ( $filename == undef or $oracle_base_home_dir == undef or $middleware_home_dir == undef or $jdk_home_dir == undef or $os_user == undef or $os_group == undef or $download_dir == undef ) {
    fail('please provide all the required parameters')
  }

  if ( $wls_domains_dir != undef) {
    # make sure you don't create the middleware home, else root will be owner
    if ($wls_domains_dir == "${middleware_home_dir}/user_projects/domains") {
        $domains_dir =  undef
    } else {
        $domains_dir =  $wls_domains_dir
    }
  }
  if ( $wls_apps_dir != undef) {
    # make sure you don't create the middleware home, else root will be owner
    if ($wls_apps_dir == "${middleware_home_dir}/user_projects/applications") {
        $apps_dir =  undef
    } else {
        $apps_dir =  $wls_apps_dir
    }
  }

  if ($version == 1036 or $version == 1111 or $version == 1211) {
    $silent_template = 'orawls/weblogic_silent_install.xml.erb'
  } elsif ( $version == 1212 or $version == 1213 or $version >= 1221 ) {

    #The oracle home location. This can be an existing Oracle Home or a new Oracle Home
    if ( $fmw_infra == true ) {
      $install_type='Fusion Middleware Infrastructure'
    } else {
      $install_type='WebLogic Server'
    }
    if $version >= 1221 {
      $new_version = 1221
    } else {
      $new_version = $version
    }
    $silent_template = "orawls/weblogic_silent_install_${new_version}.rsp.erb"

  } else  {
    fail('unknown weblogic version parameter')
  }

  $exec_path         = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"
  $ora_inventory_dir = "${oracle_base_home_dir}/oraInventory"

  Exec {
    logoutput => $log_output,
  }

  case $::kernel {
    'Linux': {
      if ( $orainstpath_dir == undef or $orainstpath_dir == '' ){
        $oraInstPath = '/etc'
      } else {
        $oraInstPath = $orainstpath_dir
      }
      $java_statement     = "java ${java_parameters}"
    }
    'SunOS': {
      $oraInstPath       = '/var/opt/oracle'
      $java_statement    = "java -d64 ${java_parameters}"
    }
    default: {
      fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
    }
  }

  if $source == undef {
    $mountPoint = 'puppet:///modules/orawls/'
  } else {
    $mountPoint = $source
  }

  $file_ext = regsubst($filename, '.*(\.jar)$', '\1')

  if $file_ext == '.jar' {
    $jar_file = true
  } else {
    $jar_file = false
  }

  if $jar_file {
    $cmd_prefix = "${java_statement} -Xmx1024m -Djava.io.tmpdir=${temp_directory} -jar "
  } else {
    $cmd_prefix = ''
  }

  if $remote_file == true {
    $weblogic_jar_location = "${download_dir}/${filename}"
  } else {
    $weblogic_jar_location = "${source}/${filename}"
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


  $oraInventory  = "${oracle_base_home_dir}/oraInventory"

  orawls::utils::orainst { "weblogic orainst ${title}":
    ora_inventory_dir => $oraInventory,
    os_group          => $os_group,
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
  }

  # if !defined(File[$download_dir]) {
  #   file { $download_dir:
  #     ensure => directory,
  #     mode   => '0777',
  #     require => Wls_directory_structure["weblogic structure ${title}"],
  #   }
  # }

  # for performance reasons, download and install or just install it
  if $remote_file == true {
    # put weblogic generic jar
    file { "${download_dir}/${filename}":
      ensure  => file,
      source  => "${mountPoint}/${filename}",
      replace => false,
      backup  => false,
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
      before  => Exec["install weblogic ${title}"],
      require => Wls_directory_structure["weblogic structure ${title}"],
    }
  }

  # de xml used by the wls installer
  file { "${download_dir}/weblogic_silent_install_${title}.xml":
    ensure  => present,
    content => template($silent_template),
    replace => true,
    mode    => '0775',
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
      command     => "${cmd_prefix}${weblogic_jar_location} ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs",
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
    case $::kernel {
      'SunOS': {
        exec { "add -d64 oraparam.ini oracle_common ${title}":
          command => "sed -e's/JRE_MEMORY_OPTIONS=/JRE_MEMORY_OPTIONS=\"-d64\"/g' ${middleware_home_dir}/oui/oraparam.ini > ${temp_directory}/wls.tmp && mv ${temp_directory}/wls.tmp ${middleware_home_dir}/oui/oraparam.ini",
          unless  => "grep 'JRE_MEMORY_OPTIONS=\"-d64\"' ${middleware_home_dir}/oui/oraparam.ini",
          require => Exec["install weblogic ${title}"],
          path    => $exec_path,
          user    => $os_user,
          group   => $os_group,
        }
      }
    }

  } else {
    exec {"install weblogic ${title}":
      command     => "${cmd_prefix}${weblogic_jar_location} -Djava.io.tmpdir=${temp_directory} -Duser.country=US -Duser.language=en -mode=silent ${validation_string} ${force_string} -log=${temp_directory}/wls_${title}.out -log_priority=info -silent_xml=${download_dir}/weblogic_silent_install_${title}.xml",
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
