# == Define: orawls::wlstexec
#
# executes a wlst script
#
define orawls::wlstexec (
  $version                    = hiera('wls_version'               , 1111),  # 1036|1111|1211|1212
  $domain_name                = hiera('domain_name'               , undef),
  $weblogic_type              = undef,
  $weblogic_object_name       = undef,
  $script                     = undef,
  $params                     = undef,
  $middleware_home_dir        = hiera('wls_middleware_home_dir'   , undef), # /opt/oracle/middleware11gR1
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'     , undef), # /opt/oracle/middleware11gR1/wlserver_103
  $jdk_home_dir               = hiera('wls_jdk_home_dir'          , undef), # /usr/java/jdk1.7.0_45
  $adminserver_address        = hiera('domain_adminserver_address', "localhost"),
  $adminserver_port           = hiera('domain_adminserver_port'   , 7001),
  $userConfigFile             = hiera('domain_user_config_file'   , undef),
  $userKeyFile                = hiera('domain_user_key_file'      , undef),
  $weblogic_user              = hiera('wls_weblogic_user'         , "weblogic"),
  $weblogic_password          = hiera('domain_wls_password'       , undef),
  $os_user                    = hiera('wls_os_user'               , undef), # oracle
  $os_group                   = hiera('wls_os_group'              , undef), # dba
  $download_dir               = hiera('wls_download_dir'          , undef), # /data/install
  $log_output                 = false, # true|false
)
{

  if $::override_weblogic_domain_folder == undef {
    $domain_dir = "${middleware_home_dir}/user_projects/domains"
    $app_dir    = "${middleware_home_dir}/user_projects/applications"
  } else {
    $domain_dir = "${::override_weblogic_domain_folder}/domains"
    $app_dir    = "${::override_weblogic_domain_folder}/applications"
  }


  # if these params are empty always continue
  if $domain_name == undef or $weblogic_type == undef or $weblogic_object_name == undef {
    $continue = true
  } else {
    # check if the object already exists on the weblogic domain
    $found = artifact_exists("${domain_dir}/${domain_name}", $weblogic_type, $weblogic_object_name)

    if $found == undef {
      $continue = true
      notify { "orawls::wlstexec ${title} ${version} continue true cause nill": }
    } else {
      if ($found) {
        $continue = false
      } else {
        notify { "orawls::wlstexec ${title} ${version} continue true cause not exists": }
        $continue = true
      }
    }
  }

  # use userConfigStore for the connect
  if $weblogic_password == undef {    
    $useStoreConfig = true
  } else {
    # override if config and key files are provided 
    if($userConfigFile != undef and $userKeyFile != undef) {
      $useStoreConfig = true
    }
    else {
       $useStoreConfig = false
    }
  }

  if ($continue) {

    # download the WLST script used by the WLST
    file { "${download_dir}/${title}${script}":
      path    => "${download_dir}/${title}${script}",
      content => template("orawls/wlst/wlstexec/${script}.erb"),
      ensure  => present,
      backup  => false,
      replace => true,
      mode    => 0555,
      owner   => $os_user,
      group   => $os_group,
    }

    $exec_path = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"
    case $::kernel {
      Linux: {
         $java_statement = "java"
       }
       SunOS: {
         $java_statement = "java -d64"
       }
    }
    $javaCommand = "${java_statement} -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning "

    # execute WLST script
    exec { "execwlst ${title}${script}":
      command     => "${javaCommand} ${download_dir}/${title}${script} ${weblogic_password}",
      environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                      "JAVA_HOME=${jdk_home_dir}"],
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      logoutput   => $log_output,
      require     => File["${download_dir}/${title}${script}"],
    }

    # cleanup WLST script
    exec { "rm ${download_dir}/${title}${script}":
      command   => "rm ${download_dir}/${title}${script}",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
      require   => Exec["execwlst ${title}${script}"],
    }

  }
}
