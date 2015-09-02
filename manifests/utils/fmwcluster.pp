# == Define: orawls::utils::fmwcluster
#
# transform domain to a soa,osb,bam cluster
##
define orawls::utils::fmwcluster (
  $version                    = hiera('wls_version'               , 1111),  # 1036|1111|1211|1212
  $ofm_version                = hiera('ofm_version'               , 1117),   # 1116|1117
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $jdk_home_dir               = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $wls_domains_dir            = hiera('wls_domains_dir'           , undef),
  $domain_name                = hiera('domain_name'),
  $adminserver_name           = hiera('domain_adminserver'        , 'AdminServer'),
  $adminserver_address        = hiera('domain_adminserver_address', 'localhost'),
  $adminserver_port           = hiera('domain_adminserver_port'   , 7001),
  $nodemanager_port           = hiera('domain_nodemanager_port'   , 5556),
  $soa_cluster_name           = undef,
  $bam_cluster_name           = undef,
  $osb_cluster_name           = undef,
  $oam_cluster_name           = undef,
  $oim_cluster_name           = undef,
  $ess_cluster_name           = undef,
  $bpm_enabled                = false, # true|false
  $bam_enabled                = false, # true|false
  $osb_enabled                = false, # true|false
  $soa_enabled                = false, # true|false
  $oam_enabled                = false, # true|false
  $oim_enabled                = false, # true|false
  $b2b_enabled                = false, # true|false
  $ess_enabled                = false, # true|false
  $repository_prefix          = hiera('repository_prefix'         , 'DEV'),
  $weblogic_user              = hiera('wls_weblogic_user'         , 'weblogic'),
  $weblogic_password          = hiera('domain_wls_password'),
  $os_user                    = hiera('wls_os_user'), # oracle
  $os_group                   = hiera('wls_os_group'), # dba
  $download_dir               = hiera('wls_download_dir'), # /data/install
  $log_output                 = false, # true|false
  $retain_file_store          = hiera('retain_security_file_store', false), # true|false
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
    $soa_found = soa_cluster_configured($domain_dir, $soa_cluster_name)

    if $soa_found == undef or $soa_found == true {
      $convert_soa = false
    } else {
      $convert_soa = true
    }
  }

  if ( $osb_enabled ) {
    # check if the soa is already targeted to the cluster on this weblogic domain
    $osb_found = osb_cluster_configured($domain_dir, $osb_cluster_name)

    if $osb_found == undef or $osb_found == true {
      $convert_osb = false
    } else {
      $convert_osb = true
    }
  }

  if ( $bam_enabled ) {
    # check if the soa is already targeted to the cluster on this weblogic domain
    $bam_found = bam_cluster_configured($domain_dir, $bam_cluster_name)

    if $bam_found == undef or $bam_found == true {
      $convert_bam = false
    } else {
      $convert_bam = true
    }
  }

  if $convert_soa or $convert_osb or $convert_bam {

    $exec_path = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

    if ( $version == 1213 ) {
      #shutdown adminserver for offline WLST scripts
      orawls::control{"ShutdownAdminServerForSoa${title}":
        weblogic_home_dir   => $weblogic_home_dir,
        jdk_home_dir        => $jdk_home_dir,
        wls_domains_dir     => $domains_dir,
        domain_name         => $domain_name,
        server_type         => 'admin',
        target              => 'Server',
        server              => $adminserver_name,
        adminserver_address => $adminserver_address,
        adminserver_port    => $adminserver_port,
        nodemanager_port    => $nodemanager_port,
        action              => 'stop',
        weblogic_user       => $weblogic_user,
        weblogic_password   => $weblogic_password,
        os_user             => $os_user,
        os_group            => $os_group,
        download_dir        => $download_dir,
        log_output          => $log_output,
      }

      file { "${download_dir}/assignOsbSoaBpmBamToClusters${title}.py":
        ensure  => present,
        content => template('orawls/wlst/wlstexec/fmw/assignOsbSoaBpmBamToClusters_1213.py.erb'),
        backup  => false,
        replace => true,
        mode    => '0775',
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
        weblogic_home_dir   => $weblogic_home_dir,
        jdk_home_dir        => $jdk_home_dir,
        wls_domains_dir     => $domains_dir,
        domain_name         => $domain_name,
        server_type         => 'admin',
        target              => 'Server',
        server              => $adminserver_name,
        adminserver_address => $adminserver_address,
        adminserver_port    => $adminserver_port,
        nodemanager_port    => $nodemanager_port,
        action              => 'start',
        weblogic_user       => $weblogic_user,
        weblogic_password   => $weblogic_password,
        os_user             => $os_user,
        os_group            => $os_group,
        download_dir        => $download_dir,
        log_output          => $log_output,
        require             => Exec["execwlst assignOsbSoaBpmBamToClusters.py ${title}"],
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
          mode    => '0775',
          owner   => $os_user,
          group   => $os_group,
        }
        exec { "execwlst create OPSS store ${domain_name} ${title}":
          command     => "${middleware_home_dir}/oracle_common/common/bin/wlst.sh ${download_dir}/migrateSecurityStore_${domain_name}.py ${weblogic_password}",
          environment => ["JAVA_HOME=${jdk_home_dir}"],
          require     => File["migrateSecurityStore.py ${domain_name} ${title}"],
          timeout     => 0,
          before      => Orawls::Control["ShutdownAdminServerForSoa${title}"],
          logoutput   => $log_output,
        }
      }

      #shutdown adminserver for offline WLST scripts
      orawls::control{"ShutdownAdminServerForSoa${title}":
        weblogic_home_dir   => $weblogic_home_dir,
        jdk_home_dir        => $jdk_home_dir,
        wls_domains_dir     => $domains_dir,
        domain_name         => $domain_name,
        server_type         => 'admin',
        target              => 'Server',
        server              => $adminserver_name,
        adminserver_address => $adminserver_address,
        adminserver_port    => $adminserver_port,
        nodemanager_port    => $nodemanager_port,
        action              => 'stop',
        weblogic_user       => $weblogic_user,
        weblogic_password   => $weblogic_password,
        os_user             => $os_user,
        os_group            => $os_group,
        download_dir        => $download_dir,
        log_output          => $log_output,
      }

      file { "${download_dir}/assignOsbSoaBpmBamToClusters${title}.py":
        ensure  => present,
        content => template('orawls/wlst/wlstexec/fmw/assignOsbSoaBpmBamToClusters.py.erb'),
        backup  => false,
        replace => true,
        mode    => '0775',
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
          mode    => '0775',
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
          mode    => '0775',
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
            mode    => '0775',
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
          mode    => '0775',
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
        weblogic_home_dir   => $weblogic_home_dir,
        jdk_home_dir        => $jdk_home_dir,
        wls_domains_dir     => $domains_dir,
        domain_name         => $domain_name,
        server_type         => 'admin',
        target              => 'Server',
        server              => $adminserver_name,
        adminserver_address => $adminserver_address,
        adminserver_port    => $adminserver_port,
        nodemanager_port    => $nodemanager_port,
        action              => 'start',
        weblogic_user       => $weblogic_user,
        weblogic_password   => $weblogic_password,
        os_user             => $os_user,
        os_group            => $os_group,
        download_dir        => $download_dir,
        log_output          => $log_output,
        require             => Exec[$last_step],
      }

      # the py script used by the wlst
      file { "${download_dir}/changeWorkmanagers${title}.py":
        ensure  => present,
        content => template('orawls/wlst/wlstexec/fmw/changeWorkmanagers.py.erb'),
        backup  => false,
        replace => true,
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
      }

      # execute WLST script
      exec { "execwlst changeWorkmanagers.py ${title}":
        command     => "${javaCommand} ${download_dir}/changeWorkmanagers${title}.py ${weblogic_password}",
        environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
                        "JAVA_HOME=${jdk_home_dir}"],
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [File["${download_dir}/changeWorkmanagers${title}.py"],
                        Orawls::Control["StartupAdminServerForSoa${title}"]],
      }
    }
    else {
      fail('unknown version')
    }
  }
}
