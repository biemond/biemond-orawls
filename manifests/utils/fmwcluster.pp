# == Define: orawls::utils::fmwcluster
#
# transform domain to a soa,osb,bam cluster
##
define orawls::utils::fmwcluster (
  $version                    = hiera('wls_version'               , 1111),  # 1036|1111|1211|1212
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'     , undef), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir'   , undef), # /opt/oracle/middleware11gR1
  $jdk_home_dir               = hiera('wls_jdk_home_dir'          , undef), # /usr/java/jdk1.7.0_45
  $domain_name                = hiera('domain_name'               , undef),
  $domain_dir                 = undef,
  $adminserver_name           = hiera('domain_adminserver'        , "AdminServer"),
  $adminserver_address        = hiera('domain_adminserver_address', "localhost"),
  $adminserver_port           = hiera('domain_adminserver_port'   , 7001),
  $nodemanager_port           = hiera('domain_nodemanager_port'   , 5556),
  $soa_cluster_name           = undef,
  $bam_cluster_name           = undef,
  $osb_cluster_name           = undef,
  $bpm_enabled                = false, # true|false 
  $bam_enabled                = false, # true|false 
  $osb_enabled                = false, # true|false 
  $soa_enabled                = false, # true|false 
  $weblogic_user              = hiera('wls_weblogic_user'         , "weblogic"),
  $weblogic_password          = hiera('domain_wls_password'       , undef),
  $os_user                    = hiera('wls_os_user'               , undef), # oracle
  $os_group                   = hiera('wls_os_group'              , undef), # dba
  $download_dir               = hiera('wls_download_dir'          , undef), # /data/install
  $log_output                 = false, # true|false
)
{

  if ( $soa_enabled ) {
    # check if the soa is already targeted to the cluster on this weblogic domain
    $found = soa_cluster_configured($domain_name, $soa_cluster_name, $version)

    if $found == undef {
      $continue = false
      notify { "orawls::utils::fmwcluster ${title} ${version} continue false cause nill": }
    } else {
      if ($found) {
        $continue = false
      } else {
        notify { "orawls::utils::fmwcluster ${title} ${version} continue true cause not exists": }
        $continue = true
      }
    }
  } elsif ( $osb_enabled ) {
    # check if the osb is already targeted to the cluster on this weblogic domain
    $found = osb_cluster_configured($domain_name, $osb_cluster_name, $version)

    if $found == undef {
      $continue = false
      notify { "orawls::utils::fmwcluster ${title} ${version} continue false cause nill": }
    } else {
      if ($found) {
        $continue = false
      } else {
        notify { "orawls::utils::fmwcluster ${title} ${version} continue true cause not exists": }
        $continue = true
      }
    }
  }

  if ($continue) {

    if ( $osb_enabled  ) {
      $last_step = "execwlst osb-createUDD.py"
    } else  {
      $last_step = "execwlst soa-bpm-createUDD.py"
    }

    #shutdown adminserver for offline WLST scripts
    orawls::control{'ShutdownAdminServerForSoa':
      weblogic_home_dir          => $weblogic_home_dir,
      jdk_home_dir               => $jdk_home_dir,
      domain_name                => $domain_name,
      domain_dir                 => $domain_dir,
      server_type                => 'admin',
      target                     => 'Server',
      server                     => $adminserver_name,
      adminserver_address        => $adminserver_address,
      adminserver_port           => $adminserver_port,
      nodemanager_port           => $nodemanager_port,
      action                     => 'stop',
      weblogic_user              => $weblogic_user,
      weblogic_password          => $weblogic_password,
      os_user                    => $os_user,
      os_group                   => $os_group,
      download_dir               => $download_dir,
      log_output                 => $log_output,
    }

    file { "${download_dir}/assignOsbSoaBpmBamToClusters.py":
      content => template("orawls/wlst/wlstexec/fmw/assignOsbSoaBpmBamToClusters.py.erb"),
      ensure  => present,
      backup  => false,
      replace => true,
      mode    => 0775,
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

    # reorder all apps,libraries, startup , shutdown and datasources
    exec { "execwlst assignOsbSoaBpmBamToClusters.py":
      command     => "${javaCommand} ${download_dir}/assignOsbSoaBpmBamToClusters.py",
      environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                      "JAVA_HOME=${jdk_home_dir}"],
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      logoutput   => $log_output,
      require     => [ File["${download_dir}/assignOsbSoaBpmBamToClusters.py"],
                       Orawls::Control['ShutdownAdminServerForSoa'],
                     ]
    }

    if $soa_enabled == true {

      if $bam_enabled == true {
        $action = "--bamcluster ${bam_cluster_name} --soacluster ${soa_cluster_name}"
      } else {
        $action = "--soacluster ${soa_cluster_name}"
      }

      file { "${download_dir}/soa-createUDD.py":
        content => template("orawls/wlst/wlstexec/fmw/soa-createUDD.py.erb"),
        ensure  => present,
        backup  => false,
        replace => true,
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
      }

      # execute WLST script
      exec { "execwlst soa-createUDD.py":
        command     => "${javaCommand} ${download_dir}/soa-createUDD.py --domain_home ${domain_dir} ${action} --create_jms true",
        environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                        "JAVA_HOME=${jdk_home_dir}"],
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [ Orawls::Control['ShutdownAdminServerForSoa'],
                         File["${download_dir}/soa-createUDD.py"],
                         Exec["execwlst assignOsbSoaBpmBamToClusters.py"],
                       ]
      }
      # the py script used by the wlst
      file { "${download_dir}/soa-bpm-createUDD.py":
        content => template("orawls/wlst/wlstexec/fmw/soa-bpm-createUDD.py.erb"),
        ensure  => present,
        backup  => false,
        replace => true,
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
      }

      # execute WLST script
      exec { "execwlst soa-bpm-createUDD.py":
        command     => "${javaCommand} ${download_dir}/soa-bpm-createUDD.py",
        environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                        "JAVA_HOME=${jdk_home_dir}"],
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [ File["${download_dir}/soa-bpm-createUDD.py"],
                         Orawls::Control['ShutdownAdminServerForSoa'],
                         Exec["execwlst assignOsbSoaBpmBamToClusters.py"],
                         Exec["execwlst soa-createUDD.py"],
                       ]
      }

    } 
    if $osb_enabled == true {

      if ( $soa_enabled  ) {
        $last_soa_step = "execwlst soa-bpm-createUDD.py"
      } else  {
        $last_soa_step = "execwlst assignOsbSoaBpmBamToClusters.py"
      }

      # the py script used by the wlst
      file { "${download_dir}/osb-createUDD.py":
        content => template("orawls/wlst/wlstexec/fmw/osb-createUDD.py.erb"),
        ensure  => present,
        backup  => false,
        replace => true,
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
      }

      # execute WLST script
      exec { "execwlst osb-createUDD.py":
        command     => "${javaCommand} ${download_dir}/osb-createUDD.py",
        environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                        "JAVA_HOME=${jdk_home_dir}"],
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [ File["${download_dir}/osb-createUDD.py"],
                         Orawls::Control['ShutdownAdminServerForSoa'],
                         Exec[$last_soa_step],
                       ]
      }
    }

    #startup adminserver for offline WLST scripts
    orawls::control{'StartupAdminServerForSoa':
      weblogic_home_dir          => $weblogic_home_dir,
      jdk_home_dir               => $jdk_home_dir,
      domain_name                => $domain_name,
      domain_dir                 => $domain_dir,
      server_type                => 'admin',
      target                     => 'Server',
      server                     => $adminserver_name,
      adminserver_address        => $adminserver_address,
      adminserver_port           => $adminserver_port,
      nodemanager_port           => $nodemanager_port,
      action                     => 'start',
      weblogic_user              => $weblogic_user,
      weblogic_password          => $weblogic_password,
      os_user                    => $os_user,
      os_group                   => $os_group,
      download_dir               => $download_dir,
      log_output                 => $log_output,
      require                    => Exec[$last_step],       
    }
  }

}
