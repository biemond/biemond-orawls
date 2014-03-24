# == Class: orawls::weblogic
#
class orawls::weblogic (
  $version              = 1111,  # 1036|1111|1211|1212
  $filename             = undef, # wls1036_generic.jar|wls1211_generic.jar|wls_121200.jar|oepe-wls-indigo-installer-11.1.1.8.0.201110211138-10.3.6-linux32.bin
  $oracle_base_home_dir = undef, # /opt/oracle
  $middleware_home_dir  = undef, # /opt/oracle/middleware11gR1
  $domains_dir          = undef, # /opt/oracle/wlsdomains/domains
  $apps_dir             = undef, # /opt/oracle/wlsdomains/applications
  $fmw_infra            = false, # true|false 12.1.2 option -> plain weblogic or fmw infra
  $jdk_home_dir         = undef, # /usr/java/jdk1.7.0_45
  $os_user              = undef, # oracle
  $os_group             = undef, # dba
  $download_dir         = undef, # /data/install
  $source               = undef, # puppet:///modules/orawls/ | /mnt | /vagrant
  $remote_file          = true,  # true|false
  $javaParameters       = '',    # '-Dspace.detection=false'
  $log_output           = false, # true|false
  $temp_directory       = '/tmp',# /tmp temporay directory for files extractions
) {

  if ($version == 1036 or $version == 1111 or $version == 1211) {
    $silent_template = "orawls/weblogic_silent_install.xml.erb"
  } elsif ( $version == 1212) {

    #The oracle home location. This can be an existing Oracle Home or a new Oracle Home
    if ( $fmw_infra == true ) {
      $install_type="Fusion Middleware Infrastructure"
    } else {
      $install_type="WebLogic Server"
    }
    $silent_template = "orawls/weblogic_silent_install_1212.rsp.erb"

  } else  {
    fail('unknown weblogic version parameter')
  }

  $exec_path         = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"
  $ora_inventory_dir = "${oracle_base_home_dir}/oraInventory"

  Exec {
    logoutput => $log_output,
  }

  # check if the middleware already exists
  $found = wls_exists($middleware_home_dir)

  if $found == undef {
    $continue = true
  } else {
    if ($found) {
      $continue = false
    } else {
      notify { "orawls::weblogic version ${version} ${middleware_home_dir} does not exists": }
      $continue = true
    }
  }

  if ($continue) {
    if $source == undef {
      $mountPoint = "puppet:///modules/orawls/"
    } else {
      $mountPoint = $source
    }
    
    $oraInventory  = "${oracle_base_home_dir}/oraInventory"
    orawls::utils::orainst { "weblogic orainst ${version}":
      ora_inventory_dir => $oraInventory,
      os_group          => $os_group,
    }

    orawls::utils::structure{"weblogic structure ${version}":
      oracle_base_home_dir => $oracle_base_home_dir,
      ora_inventory_dir    => $ora_inventory_dir,
      domains_dir          => $domains_dir,
      apps_dir             => $apps_dir,
      os_user              => $os_user,
      os_group             => $os_group,
      download_dir         => $download_dir,
      log_output           => $log_output,
    }

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
        require => Orawls::Utils::Structure["weblogic structure ${version}"],
      }
    }

    # de xml used by the wls installer
    file { "${download_dir}/weblogic_silent_install.xml":
      ensure  => present,
      content => template($silent_template),
      replace => true,
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
      require => Orawls::Utils::Structure["weblogic structure ${version}"],
    }

    case $::kernel {
      Linux: {
        $oraInstPath        = "/etc"
        $java_statement     = "java ${javaParameters}"
       }
       SunOS: {
         $oraInstPath       = "/var/opt"
         $java_statement    = "java -d64 ${javaParameters}"
       }
    }

    $file_ext = regsubst($filename, '.*(\.jar)$', '\1')

    if $file_ext == '.jar' {
      if ! $jar_file {
        $jar_file = true
      }    
    } else {
      $jar_file = false
    }    

    if $jar_file {
      $cmd_prefix = "${java_statement} -Xmx1024m -Djava.io.tmpdir=${temp_directory} -jar " 
    } else {
      $cmd_prefix = ""
    }

    notify { "orawls::weblogic $cmd_prefix": }

    if ($version == 1212) {

      $command = "-silent -responseFile ${download_dir}/weblogic_silent_install.xml "

      if $remote_file == true {
        exec { "install weblogic ${version}":
          command     => "${cmd_prefix}${download_dir}/${filename} -Djava.io.tmpdir=${temp_directory} ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs",
          environment => ["JAVA_VENDOR=Sun", "JAVA_HOME=${jdk_home_dir}"],
          timeout     => 0,
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          require     => [Orawls::Utils::Structure["weblogic structure ${version}"],
                          Orawls::Utils::Orainst["weblogic orainst ${version}"],
                          File["${download_dir}/${filename}"],
                          File["${download_dir}/weblogic_silent_install.xml"]],
        }
      } else {
        exec { "install weblogic ${version}":
          command     => "${cmd_prefix}${source}/${filename} -Djava.io.tmpdir=${temp_directory} ${command} -invPtrLoc ${oraInstPath}/oraInst.loc -ignoreSysPrereqs",
          environment => ["JAVA_VENDOR=Sun", "JAVA_HOME=${jdk_home_dir}"],
          timeout     => 0,
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          require     => [Orawls::Utils::Structure["weblogic structure ${version}"],
                          Orawls::Utils::Orainst["weblogic orainst ${version}"],
                          File["${download_dir}/weblogic_silent_install.xml"]],
        }
      }
      # OPatch native lib fix for 64 solaris
      case $::kernel {
        SunOS: {
          exec { "add -d64 oraparam.ini oracle_common":
            command => "sed -e's/JRE_MEMORY_OPTIONS=/JRE_MEMORY_OPTIONS=\"-d64\"/g' ${middleware_home_dir}/oui/oraparam.ini > ${temp_directory}/wls.tmp && mv ${temp_directory}/wls.tmp ${middleware_home_dir}/oui/oraparam.ini",
            require => Exec["install weblogic ${version}"],
            path    => $exec_path,
            user    => $os_user,
            group   => $os_group,
          }
        }
      }

    } else {

      if $remote_file == true {
        exec {"install weblogic ${version}":
          command     => "${cmd_prefix}${download_dir}/${filename} -Djava.io.tmpdir=${temp_directory} -mode=silent -silent_xml=${download_dir}/weblogic_silent_install.xml",
          environment => ["JAVA_VENDOR=Sun","JAVA_HOME=${jdk_home_dir}"],
          timeout     => 0,
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          require     => [Orawls::Utils::Structure["weblogic structure ${version}"],
                          File["${download_dir}/${filename}"],
                          File["${download_dir}/weblogic_silent_install.xml"]],
        }
      } else {
        exec {"install weblogic ${version}":
          command     => "${cmd_prefix}${source}/${filename} -Djava.io.tmpdir=${temp_directory} -mode=silent -silent_xml=${download_dir}/weblogic_silent_install.xml",
          environment => ["JAVA_VENDOR=Sun","JAVA_HOME=${jdk_home_dir}"],
          timeout     => 0,
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          require     => [Orawls::Utils::Structure["weblogic structure ${version}"],
                          File["${download_dir}/weblogic_silent_install.xml"]],
        }

      }
    }
  }
}
