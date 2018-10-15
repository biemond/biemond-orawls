#
# utils::fmwcluster define
#
# transform a domain to a soa, osb, bam, ess, oim, oam cluster
#
# @param version used weblogic software like 1036
# @param ofm_version used FMW software
# @param wls_domains_dir root directory for all the WebLogic domains
# @param middleware_home_dir directory of the Oracle software inside the oracle base directory
# @param domain_name the domain name which to connect to
# @param adminserver_address the adminserver network name or ip, default = localhost
# @param adminserver_port the adminserver port number, default = 7001
# @param weblogic_user the weblogic administrator username
# @param weblogic_password the weblogic domain password
# @param weblogic_home_dir directory of the WebLogic software inside the middleware directory
# @param jdk_home_dir full path to the java home directory like /usr/java/default
# @param os_user the user name with oracle as default
# @param os_group the group name with dba as default
# @param log_output show all the output of the the exec actions
# @param download_dir the directory for temporary created files by this class
# @param jsse_enabled enable JSSE on the JVM
# @param custom_trust have your own trustore JKS or using the default
# @param trust_keystore_file the full path to the trust keystore
# @param trust_keystore_passphrase the password of the trust keystore
# @param adminserver_name WebLogic AdminServer name
# @param nodemanager_port the port number of the used NodeManager
# @param soa_cluster_name the SOA Suite cluster name
# @param bam_cluster_name the SOA Suite BAM cluster name
# @param osb_cluster_name the Service Bus cluster name
# @param oam_cluster_name the OAM cluster name
# @param oim_cluster_name the OIM cluster name
# @param ess_cluster_name the SOA Suite ESS cluster name
# @param bi_cluster_name the BI Cluster name
# @param bpm_enabled BPM enabled on SOA SUITE
# @param bam_enabled BAM enabled on SOA SUITE
# @param osb_enabled OSB enabled
# @param soa_enabled SOA SUITE enabled
# @param oam_enabled OAM enabled
# @param oim_enabled OIM enabled
# @param b2b_enabled B2B enabled
# @param ess_enabled ESS enabled on SOA SUITE
# @param bi_enabled BI enabled
# @param repository_prefix the used RCU prefix
# @param nodemanager_secure_listener use the secure nodemanager port
# @param retain_file_store
#
define orawls::utils::fmwcluster (
  Integer $version                                        = $::orawls::weblogic::version,
  Integer $ofm_version                                    = 1117,   # 1116|1117
  String $weblogic_home_dir                               = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir,
  String $jdk_home_dir                                    = $::orawls::weblogic::jdk_home_dir,
  String $domain_name                                     = undef,
  Optional[String] $wls_domains_dir                       = $::orawls::weblogic::wls_domains_dir,
  String $adminserver_name                                = 'AdminServer',
  String $adminserver_address                             = 'localhost',
  Integer $adminserver_port                               = 7001,
  Integer $nodemanager_port                               = 5556,
  Optional[String] $soa_cluster_name                      = undef,
  Optional[String] $bam_cluster_name                      = undef,
  Optional[String] $osb_cluster_name                      = undef,
  Optional[String] $oam_cluster_name                      = undef,
  Optional[String] $oim_cluster_name                      = undef,
  Optional[String] $ess_cluster_name                      = undef,
  Optional[String] $bi_cluster_name                       = undef,
  Boolean $bpm_enabled                         = false, # true|false
  Boolean $bam_enabled                         = false, # true|false
  Boolean $osb_enabled                         = false, # true|false
  Boolean $soa_enabled                         = false, # true|false
  Boolean $oam_enabled                         = false, # true|false
  Boolean $oim_enabled                         = false, # true|false
  Boolean $b2b_enabled                         = false, # true|false
  Boolean $ess_enabled                         = false, # true|false
  Boolean $bi_enabled                          = false, # true|false
  String $repository_prefix                    = 'DEV',
  String $weblogic_user                        = 'weblogic',
  String $weblogic_password                    = undef,
  String $os_user                              = $::orawls::weblogic::os_user,
  String $os_group                             = $::orawls::weblogic::os_group,
  String $download_dir                         = $::orawls::weblogic::download_dir,
  Boolean $log_output                          = $::orawls::weblogic::log_output,
  Boolean $retain_file_store                   = false,
  Boolean $jsse_enabled                        = false,
  Boolean $custom_trust                        = false,
  Optional[String] $trust_keystore_file        = undef,
  Optional[String] $trust_keystore_passphrase  = undef,
  Boolean $nodemanager_secure_listener         = true,
)
{
  if ( $wls_domains_dir == undef or $wls_domains_dir == '') {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  $domain_dir = "${domains_dir}/${domain_name}"

  if ( $soa_enabled ) {
    # check if the soa is already targeted to the cluster on this weblogic domain
    $soa_found = orawls::product_configured($domain_dir, $soa_cluster_name, 'soa')

    if $soa_found == undef or $soa_found == true {
      $convert_soa = false
    } else {
      $convert_soa = true
    }
  } else {
    $convert_soa = false
  }

  if ( $osb_enabled ) {
    # check if the soa is already targeted to the cluster on this weblogic domain
    $osb_found = orawls::product_configured($domain_dir, $osb_cluster_name, 'osb')

    if $osb_found == undef or $osb_found == true {
      $convert_osb = false
    } else {
      $convert_osb = true
    }
  } else {
    $convert_osb = false
  }

  if ( $bam_enabled ) {
    # check if the soa is already targeted to the cluster on this weblogic domain
    $bam_found = orawls::product_configured($domain_dir, $bam_cluster_name, 'bam')

    if $bam_found == undef or $bam_found == true {
      $convert_bam = false
    } else {
      $convert_bam = true
    }
  } else {
    $convert_bam = false
  }

  if $convert_soa or $convert_osb or $convert_bam {

    $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

    if ( $version == 1213 or $version >= 1221 ) {
      #shutdown adminserver for offline WLST scripts
      orawls::control{"ShutdownAdminServerForSoa${title}":
        middleware_home_dir         => $middleware_home_dir,
        weblogic_home_dir           => $weblogic_home_dir,
        jdk_home_dir                => $jdk_home_dir,
        wls_domains_dir             => $domains_dir,
        domain_name                 => $domain_name,
        server_type                 => 'admin',
        target                      => 'Server',
        server                      => $adminserver_name,
        adminserver_address         => $adminserver_address,
        adminserver_port            => $adminserver_port,
        nodemanager_secure_listener => $nodemanager_secure_listener,
        nodemanager_port            => $nodemanager_port,
        jsse_enabled                => $jsse_enabled,
        custom_trust                => $custom_trust,
        trust_keystore_file         => $trust_keystore_file,
        trust_keystore_passphrase   => $trust_keystore_passphrase,
        action                      => 'stop',
        weblogic_user               => $weblogic_user,
        weblogic_password           => $weblogic_password,
        os_user                     => $os_user,
        os_group                    => $os_group,
        download_dir                => $download_dir,
        log_output                  => $log_output,
      }
      if $version >= 1221 {
        $new_version = 1221
      } else {
        $new_version = $version
      }

      file { "${download_dir}/assignOsbSoaBpmBamToClusters${title}.py":
        ensure  => present,
        content => template("orawls/wlst/wlstexec/fmw/assignOsbSoaBpmBamToClusters_${new_version}.py.erb"),
        backup  => false,
        replace => true,
        mode    => lookup('orawls::permissions'),
        owner   => $os_user,
        group   => $os_group,
      }

      # reorder all apps,libraries, startup , shutdown and datasources
      exec { "execwlst assignOsbSoaBpmBamToClusters.py ${title}":
        command   => "${middleware_home_dir}/oracle_common/common/bin/wlst.sh ${download_dir}/assignOsbSoaBpmBamToClusters${title}.py",
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        timeout   => 0,
        logoutput => $log_output,
        require   => [File["${download_dir}/assignOsbSoaBpmBamToClusters${title}.py"],
                      Orawls::Control["ShutdownAdminServerForSoa${title}"],],
      }
      #startup adminserver for offline WLST scripts
      orawls::control{"StartupAdminServerForSoa${title}":
        middleware_home_dir         => $middleware_home_dir,
        weblogic_home_dir           => $weblogic_home_dir,
        jdk_home_dir                => $jdk_home_dir,
        wls_domains_dir             => $domains_dir,
        domain_name                 => $domain_name,
        server_type                 => 'admin',
        target                      => 'Server',
        server                      => $adminserver_name,
        adminserver_address         => $adminserver_address,
        adminserver_port            => $adminserver_port,
        nodemanager_secure_listener => $nodemanager_secure_listener,
        nodemanager_port            => $nodemanager_port,
        action                      => 'start',
        jsse_enabled                => $jsse_enabled,
        custom_trust                => $custom_trust,
        trust_keystore_file         => $trust_keystore_file,
        trust_keystore_passphrase   => $trust_keystore_passphrase,
        weblogic_user               => $weblogic_user,
        weblogic_password           => $weblogic_password,
        os_user                     => $os_user,
        os_group                    => $os_group,
        download_dir                => $download_dir,
        log_output                  => $log_output,
        require                     => Exec["execwlst assignOsbSoaBpmBamToClusters.py ${title}"],
      }
    }
    elsif ( $version <= 1111 ) {

      case $::kernel {
        'Linux': {
          $java_statement = 'java'
        }
        'SunOS': {
          $java_statement = 'java -d64'
        }
        default: {
          fail("Unrecognized operating system ${::kernel}")
        }
      }
      $javaCommand = "${java_statement} -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning "

      if ( $osb_enabled  == true ) {
        $last_step = "execwlst osb-createUDD.py ${title}"
      } elsif ($oim_enabled == true ) {
        $last_step = "execwlst oim-createUDD.py ${title}"
      } else {
        $last_step = "execwlst soa-bpm-createUDD.py ${title}"
      }

      # only for soa suite 1036 or 1111 and not if OAM is already installed
      if ( $soa_enabled  == true and $oam_enabled == false and $retain_file_store == false) {
        # the domain.py used by the wlst
        file { "migrateSecurityStore.py ${domain_name} ${title}":
          ensure  => present,
          path    => "${download_dir}/migrateSecurityStore_${domain_name}.py",
          content => template('orawls/wlst/wlstexec/fmw/migrateSecurityStore.py.erb'),
          replace => true,
          backup  => false,
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
        }
        exec { "execwlst create OPSS store ${domain_name} ${title}":
          command     => "${middleware_home_dir}/oracle_common/common/bin/wlst.sh ${download_dir}/migrateSecurityStore_${domain_name}.py \'${weblogic_password}\'",
          environment => ["JAVA_HOME=${jdk_home_dir}"],
          require     => File["migrateSecurityStore.py ${domain_name} ${title}"],
          timeout     => 0,
          before      => Orawls::Control["ShutdownAdminServerForSoa${title}"],
          logoutput   => $log_output,
        }
      }

      #shutdown adminserver for offline WLST scripts
      orawls::control{"ShutdownAdminServerForSoa${title}":
        middleware_home_dir         => $middleware_home_dir,
        weblogic_home_dir           => $weblogic_home_dir,
        jdk_home_dir                => $jdk_home_dir,
        wls_domains_dir             => $domains_dir,
        domain_name                 => $domain_name,
        server_type                 => 'admin',
        target                      => 'Server',
        server                      => $adminserver_name,
        adminserver_address         => $adminserver_address,
        adminserver_port            => $adminserver_port,
        nodemanager_secure_listener => $nodemanager_secure_listener,
        nodemanager_port            => $nodemanager_port,
        action                      => 'stop',
        jsse_enabled                => $jsse_enabled,
        custom_trust                => $custom_trust,
        trust_keystore_file         => $trust_keystore_file,
        trust_keystore_passphrase   => $trust_keystore_passphrase,
        weblogic_user               => $weblogic_user,
        weblogic_password           => $weblogic_password,
        os_user                     => $os_user,
        os_group                    => $os_group,
        download_dir                => $download_dir,
        log_output                  => $log_output,
      }

      file { "${download_dir}/assignOsbSoaBpmBamToClusters${title}.py":
        ensure  => present,
        content => template('orawls/wlst/wlstexec/fmw/assignOsbSoaBpmBamToClusters.py.erb'),
        backup  => false,
        replace => true,
        mode    => lookup('orawls::permissions'),
        owner   => $os_user,
        group   => $os_group,
      }

      # reorder all apps,libraries, startup , shutdown and datasources
      exec { "execwlst assignOsbSoaBpmBamToClusters.py ${title}":
        command     => "${javaCommand} ${download_dir}/assignOsbSoaBpmBamToClusters${title}.py",
        environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                        "JAVA_HOME=${jdk_home_dir}"],
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [File["${download_dir}/assignOsbSoaBpmBamToClusters${title}.py"],
                        Orawls::Control["ShutdownAdminServerForSoa${title}"],]
      }

      if ( $soa_enabled == true ){

        if $bam_enabled == true {
          $action = "--bamcluster ${bam_cluster_name} --soacluster ${soa_cluster_name}"
        } else {
          $action = "--soacluster ${soa_cluster_name}"
        }

        file { "${download_dir}/soa-createUDD${title}.py":
          ensure  => present,
          content => template('orawls/wlst/wlstexec/fmw/soa-createUDD.py.erb'),
          backup  => false,
          replace => true,
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
        }

        # execute WLST script
        exec { "execwlst soa-createUDD.py ${title}":
          command     => "${javaCommand} ${download_dir}/soa-createUDD${title}.py --domain_home ${domain_dir} ${action} --create_jms true",
          environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                          "JAVA_HOME=${jdk_home_dir}"],
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          logoutput   => $log_output,
          require     => [Orawls::Control["ShutdownAdminServerForSoa${title}"],
                          File["${download_dir}/soa-createUDD${title}.py"],
                          Exec["execwlst assignOsbSoaBpmBamToClusters.py ${title}"],],
        }
        # the py script used by the wlst
        file { "${download_dir}/soa-bpm-createUDD${title}.py":
          ensure  => present,
          content => template('orawls/wlst/wlstexec/fmw/soa-bpm-createUDD.py.erb'),
          backup  => false,
          replace => true,
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
        }

        # execute WLST script
        exec { "execwlst soa-bpm-createUDD.py ${title}":
          command     => "${javaCommand} ${download_dir}/soa-bpm-createUDD${title}.py",
          environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                          "JAVA_HOME=${jdk_home_dir}"],
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          logoutput   => $log_output,
          require     => [
                          File["${download_dir}/soa-bpm-createUDD${title}.py"],
                          Orawls::Control["ShutdownAdminServerForSoa${title}"],
                          Exec["execwlst assignOsbSoaBpmBamToClusters.py ${title}"],
                          Exec["execwlst soa-createUDD.py ${title}"],]
        }

        if( $oim_enabled == true ) {
          # the py script used by the wlst
          file { "${download_dir}/oim-createUDD${title}.py":
            ensure  => present,
            content => template('orawls/wlst/wlstexec/fmw/oim-createUDD.py.erb'),
            backup  => false,
            replace => true,
            mode    => lookup('orawls::permissions'),
            owner   => $os_user,
            group   => $os_group,
          }

          # execute WLST script
          exec { "execwlst oim-createUDD.py ${title}":
            command     => "${javaCommand} ${download_dir}/oim-createUDD${title}.py",
            environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                            "JAVA_HOME=${jdk_home_dir}"],
            path        => $exec_path,
            user        => $os_user,
            group       => $os_group,
            logoutput   => $log_output,
            require     => [File["${download_dir}/oim-createUDD${title}.py"],
                            Exec["execwlst soa-bpm-createUDD.py ${title}"],]
          }
        }
      }

      if( $osb_enabled == true ) {

        if ( $soa_enabled  == true ) {
          $last_soa_step = "execwlst soa-bpm-createUDD.py ${title}"
        } else  {
          $last_soa_step = "execwlst assignOsbSoaBpmBamToClusters.py ${title}"
        }

        # the py script used by the wlst
        file { "${download_dir}/osb-createUDD${title}.py":
          ensure  => present,
          content => template('orawls/wlst/wlstexec/fmw/osb-createUDD.py.erb'),
          backup  => false,
          replace => true,
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
        }

        # execute WLST script
        exec { "execwlst osb-createUDD.py ${title}":
          command     => "${javaCommand} ${download_dir}/osb-createUDD${title}.py",
          environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                          "JAVA_HOME=${jdk_home_dir}"],
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          logoutput   => $log_output,
          require     => [File["${download_dir}/osb-createUDD${title}.py"],
                          Orawls::Control["ShutdownAdminServerForSoa${title}"],
                          Exec[$last_soa_step]],
        }
      }

      #startup adminserver for offline WLST scripts
      orawls::control{"StartupAdminServerForSoa${title}":
        middleware_home_dir         => $middleware_home_dir,
        weblogic_home_dir           => $weblogic_home_dir,
        jdk_home_dir                => $jdk_home_dir,
        wls_domains_dir             => $domains_dir,
        domain_name                 => $domain_name,
        server_type                 => 'admin',
        target                      => 'Server',
        server                      => $adminserver_name,
        adminserver_address         => $adminserver_address,
        adminserver_port            => $adminserver_port,
        nodemanager_secure_listener => $nodemanager_secure_listener,
        nodemanager_port            => $nodemanager_port,
        action                      => 'start',
        jsse_enabled                => $jsse_enabled,
        custom_trust                => $custom_trust,
        trust_keystore_file         => $trust_keystore_file,
        trust_keystore_passphrase   => $trust_keystore_passphrase,
        weblogic_user               => $weblogic_user,
        weblogic_password           => $weblogic_password,
        os_user                     => $os_user,
        os_group                    => $os_group,
        download_dir                => $download_dir,
        log_output                  => $log_output,
        require                     => Exec[$last_step],
      }

      # the py script used by the wlst
      file { "${download_dir}/changeWorkmanagers${title}.py":
        ensure  => present,
        content => template('orawls/wlst/wlstexec/fmw/changeWorkmanagers.py.erb'),
        backup  => false,
        replace => true,
        mode    => lookup('orawls::permissions'),
        owner   => $os_user,
        group   => $os_group,
      }

      # execute WLST script
      exec { "execwlst changeWorkmanagers.py ${title}":
        command     => "${javaCommand} ${download_dir}/changeWorkmanagers${title}.py \'${weblogic_password}\'",
        environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                        "JAVA_HOME=${jdk_home_dir}"],
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [File["${download_dir}/changeWorkmanagers${title}.py"],
                        Orawls::Control["StartupAdminServerForSoa${title}"]],
      }

      if( $oim_enabled == true ) {
        # the py script used by the wlst
        file { "${download_dir}/changeWorkmanagersOim${title}.py":
          ensure  => present,
          content => template('orawls/wlst/wlstexec/fmw/changeWorkmanagersOim.py.erb'),
          backup  => false,
          replace => true,
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
        }

        # execute WLST script
        exec { "execwlst changeWorkmanagersOim.py ${title}":
          command     => "${javaCommand} ${download_dir}/changeWorkmanagersOim${title}.py \'${weblogic_password}\'",
          environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                          "JAVA_HOME=${jdk_home_dir}"],
          path        => $exec_path,
          user        => $os_user,
          group       => $os_group,
          logoutput   => $log_output,
          require     => [File["${download_dir}/changeWorkmanagersOim${title}.py"],
                          Orawls::Control["StartupAdminServerForSoa${title}"],
                          Exec["execwlst changeWorkmanagers.py ${title}"]],
        }
      }
    }
    else {
      fail('unknown version')
    }
  }
}
