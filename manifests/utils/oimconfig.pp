# == Define: orawls::utils::oimconfig
#
# does all the Oracle Identity Management configuration
#
define orawls::utils::oimconfig(
  $version                    = undef,
  $oim_home                   = undef,
  $server_config              = false,
  $oim_password               = undef,
  $remote_config              = false,
  $keystore_password          = undef,
  $design_config              = false,
  $oimserver_hostname         = undef,
  $oimserver_port             = 14000,
  $soaserver_name             = 'soa_server1',
  $oimserver_name             = 'oim_server1',
  $repository_database_url    = hiera('repository_database_url'   , undef), #jdbc:oracle:thin:@192.168.50.5:1521:XE
  $repository_prefix          = hiera('repository_prefix'         , 'DEV'),
  $repository_password        = hiera('repository_password'       , 'Welcome01'),
  $jdk_home_dir               = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $wls_domains_dir            = hiera('wls_domains_dir'           , undef),
  $domain_name                = hiera('domain_name'),
  $adminserver_name           = hiera('domain_adminserver'        , 'AdminServer'),
  $adminserver_address        = hiera('domain_adminserver_address', 'localhost'),
  $adminserver_port           = hiera('domain_adminserver_port'   , 7001),
  $nodemanager_port           = hiera('domain_nodemanager_port'   , 5556),
  $weblogic_user              = hiera('wls_weblogic_user'         , 'weblogic'),
  $weblogic_password          = hiera('domain_wls_password'),
  $os_user                    = hiera('wls_os_user'), # oracle
  $os_group                   = hiera('wls_os_group'), # dba
  $download_dir               = hiera('wls_download_dir'), # /data/install
  $log_output                 = false, # true|false
) {

  if ( $wls_domains_dir == undef ) {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  $domain_dir = "${domains_dir}/${domain_name}"


  $execPath = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

  if ( $remote_config == true ) {
    file { "${download_dir}/${title}config_oim_remote.rsp":
      ensure  => present,
      content => template('orawls/oim/oim_remote.rsp.erb'),
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
    }

    exec { "config oim remote ${title}":
      command   => "${oim_home}/bin/config.sh -silent -response ${download_dir}/${title}config_oim_remote.rsp -waitforcompletion",
      timeout   => 0,
      onlyif    => "${remote_config} == true",
      require   => File["${download_dir}/${title}config_oim_remote.rsp"],
      path      => $execPath,
      user      => $os_user,
      group     => $os_group,
      logoutput => true,
    }
  }

  if ( $design_config == true  ) {
    file { "${download_dir}/${title}config_oim_design.rsp":
      ensure  => present,
      content => template('orawls/oim/oim_design.rsp.erb'),
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
    }

    exec { "config oim design ${title}":
      command   => "${oim_home}/bin/config.sh -silent -response ${download_dir}/${title}config_oim_design.rsp -waitforcompletion",
      timeout   => 0,
      require   => File["${download_dir}/${title}config_oim_design.rsp"],
      path      => $execPath,
      user      => $os_user,
      group     => $os_group,
      logoutput => true,
    }
  }

  if ( $server_config ) {

    ##if these params are empty always continue
    if $domain_dir != undef  {
      # check if oim is already configured in this weblogic domain
      $oimValue = oim_configured( $domain_dir )
    } else {
      fail('domain parameters are empty ')
    }
    #$oimValue = false
    if ( $oimValue == false ) {
      file { "${download_dir}/${title}config_oim_server.rsp":
        ensure  => present,
        content => template('orawls/oim/oim_server.rsp.erb'),
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
        backup  => false,
      }
      exec { "config oim server ${title}":
        command   => "/bin/sh -c 'unset DISPLAY;${oim_home}/bin/config.sh -silent -response ${download_dir}/${title}config_oim_server.rsp -waitforcompletion'",
        timeout   => 0,
        require   => File["${download_dir}/${title}config_oim_server.rsp"],
        path      => $execPath,
        user      => $os_user,
        group     => $os_group,
        logoutput => true,
      }

      orawls::control{'stopOIMOimServer1AfterConfig':
        weblogic_home_dir   => $weblogic_home_dir,
        jdk_home_dir        => $jdk_home_dir,
        wls_domains_dir     => $domains_dir,
        domain_name         => $domain_name,
        server_type         => 'managed',
        target              => 'Server',
        server              => $oimserver_name,
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
        require             => Exec["config oim server ${title}"],
      }

      orawls::control{'stopOIMSoaServer1AfterConfig':
        weblogic_home_dir   => $weblogic_home_dir,
        jdk_home_dir        => $jdk_home_dir,
        wls_domains_dir     => $domains_dir,
        domain_name         => $domain_name,
        server_type         => 'managed',
        target              => 'Server',
        server              => $soaserver_name,
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
        require             => [Orawls::Control['stopOIMOimServer1AfterConfig'],
                                Exec["config oim server ${title}"],],
      }

      orawls::control{'stopOIMAdminServerAfterConfig':
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
        require             => [Orawls::Control['stopOIMOimServer1AfterConfig'],
                                Orawls::Control['stopOIMSoaServer1AfterConfig'],
                                Exec["config oim server ${title}"],],
      }

      orawls::control{'startOIMAdminServerAfterConfig':
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
        require             => [Orawls::Control['stopOIMOimServer1AfterConfig'],
                                Orawls::Control['stopOIMAdminServerAfterConfig'],
                                Orawls::Control['stopOIMSoaServer1AfterConfig'],
                                Exec["config oim server ${title}"],],
      }
    }
  }
}


