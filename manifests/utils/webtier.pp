# == Define: orawls::utils::webtier
#
# Add a Webtier to the Enterprise manager
##
define orawls::utils::webtier(
  $version                    = hiera('wls_version'               , 1111),  # 1036|1111|1211|1212
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $jdk_home_dir               = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $wls_domains_dir            = hiera('wls_domains_dir'           , undef),
  $domain_name                = hiera('domain_name'),
  $adminserver_address        = hiera('domain_adminserver_address', 'localhost'),
  $adminserver_port           = hiera('domain_adminserver_port'   , 7001),
  $action_name                = 'create', #create|delete
  $webgate_configure          = false,
  $webgate_agentname          = hiera('webgate_agentname'         , undef),
  $webgate_hostidentifier     = hiera('webgate_hostidentifier'    , undef),
  $oamadminserverhostname     = hiera('oamadminserverhostname'    , localhost),
  $oamadminserverport         = hiera('oamadminserverport'        , 7001),
  $domain_configure           = true, # 11g register ohs instance with a domain
  $instance_name              = undef,
  $machine_name               = undef,
  $weblogic_user              = hiera('wls_weblogic_user'         , 'weblogic'),
  $weblogic_password          = hiera('domain_wls_password'),
  $os_user                    = hiera('wls_os_user'), # oracle
  $os_group                   = hiera('wls_os_group'), # dba
  $download_dir               = hiera('wls_download_dir'), # /data/install
  $log_output                 = false, # true|false
){
  if ( $wls_domains_dir == undef ) {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }
  $domain_dir = "${domains_dir}/${domain_name}"


  $exec_path = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

  if ( $version == 1212 or $version == 1213 or $version >= 1221 ){
    file { "${download_dir}/${title}_createWebtier.py":
      ensure  => present,
      content => template('orawls/wlst/wlstexec/fmw/createWebtier.py.erb'),
      backup  => false,
      replace => true,
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
    }

    if $action_name == 'create' {
      exec { "execwlst webtier ${title}":
        command     => "${middleware_home_dir}/ohs/common/bin/wlst.sh ${download_dir}/${title}_createWebtier.py ${weblogic_password}",
        environment => ["JAVA_HOME=${jdk_home_dir}"],
        path        => $exec_path,
        creates     => "${domain_dir}/system_components/OHS/${instance_name}",
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => File["${download_dir}/${title}_createWebtier.py"],
      }
    } else {
      exec { "execwlst webtier ${title}":
        command     => "${middleware_home_dir}/ohs/common/bin/wlst.sh ${download_dir}/${title}_createWebtier.py ${weblogic_password}",
        environment => ["JAVA_HOME=${jdk_home_dir}"],
        path        => $exec_path,
        onlyif      => "test -d ${domain_dir}/system_components/OHS/${instance_name}",
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => File["${download_dir}/${title}_createWebtier.py"],
      }
    }
  } else {

    $instance_home = "${middleware_home_dir}/Oracle_WT1/instances/${instance_name}"
    $instance_id   = "${middleware_home_dir}/Oracle_WT1/instances/${instance_name}/config/OHS/${instance_name}"

    file { "${download_dir}/${title}_configureWebtier.rsp":
      ensure  => present,
      content => template('orawls/wlst/wlstexec/fmw/configureWebtier.rsp.erb'),
      backup  => false,
      replace => true,
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
    }

    exec { "config webtier ${title}":
      command     => "/bin/sh -c 'unset DISPLAY;${middleware_home_dir}/Oracle_WT1/bin/config.sh -silent -response ${download_dir}/${title}_configureWebtier.rsp -waitforcompletion'",
      environment => ["JAVA_HOME=${jdk_home_dir}"],
      path        => $exec_path,
      creates     => "${middleware_home_dir}/Oracle_WT1/instances/${instance_name}",
      user        => $os_user,
      group       => $os_group,
      logoutput   => $log_output,
      require     => File["${download_dir}/${title}_configureWebtier.rsp"],
    }

    if ( $webgate_configure == true ) {

      # Note: rreg really should NOT be run from the "WebGate" machine
      # instead it should be run on the OAM server, the output artifacts stored in a secure place,
      # and then copied from there upon installation of the WebGate
      # for now this is an OK start

      # first create the input file:
      file { "${middleware_home_dir}/Oracle_IDM1/oam/server/rreg/input/${webgate_agentname}.xml":
        ensure  => present,
        content => template('orawls/oam/rreg_input.xml.erb'),
        backup  => false,
        replace => true,
        mode    => '0440',
        owner   => $os_user,
        group   => $os_group,
      }

      file { "${middleware_home_dir}/Oracle_IDM1/oam/server/rreg/bin/oamreg.sh":
        ensure => file,
        mode   => '0700',
      }

      # in the real world rreg wouldn't be run on the host running the WebTier bits
      exec { "Run rreg for WebGate instance ${webgate_agentname}":
        #command     => "/bin/echo -e ${middleware_home_dir}/Oracle_IDM1/oam/server/rreg/bin/oamreg.sh inband input/${webgate_agentname}.xml",
        command     => "/bin/echo -e ${weblogic_user}\\\\n${weblogic_password}\\\\n|${middleware_home_dir}/Oracle_IDM1/oam/server/rreg/bin/oamreg.sh inband input/${webgate_agentname}.xml -noprompt",
        environment => ["JAVA_HOME=${jdk_home_dir}"],
        cwd         => "${middleware_home_dir}/Oracle_IDM1/oam/server/rreg",
        creates     => "${middleware_home_dir}/Oracle_IDM1/oam/server/rreg/output/${webgate_agentname}",
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [File["${middleware_home_dir}/Oracle_IDM1/oam/server/rreg/input/${webgate_agentname}.xml"],File["${middleware_home_dir}/Oracle_IDM1/oam/server/rreg/bin/oamreg.sh"]]
      }

      exec { "Deploy webgate to ${instance_id}":
        command     => "${middleware_home_dir}/Oracle_OAMWebGate1/webgate/ohs/tools/deployWebGate/deployWebGateInstance.sh -w ${instance_id} -oh ${middleware_home_dir}/Oracle_OAMWebGate1",
        environment => "LD_LIBRARY_PATH='${middleware_home_dir}/Oracle_WT1/lib'",
        cwd         => "${middleware_home_dir}/Oracle_OAMWebGate1/webgate/ohs/tools/deployWebGate",
        creates     => "${instance_id}/webgate",
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [Exec["config webtier ${title}"],Exec["Run rreg for WebGate instance ${webgate_agentname}"],],
      }

      # copy the output from rreg to the WebGate
      # in the real world the rreg artifacts would:
      # * be copied to this host during host provisioning
      #   OR
      # * would be stored on a fileserver accessible from this host
      #   e.g. from puppet:
      file { "Copy rreg artifacts for ${instance_id}":
        path    => "${instance_id}/webgate/config",
        source  => "${middleware_home_dir}/Oracle_IDM1/oam/server/rreg/output/${webgate_agentname}",
        recurse => true,
        require => [Exec["Deploy webgate to ${instance_id}"],Exec["Run rreg for WebGate instance ${webgate_agentname}"],],
      }

      exec { "EditHttpConf to enable webgate ${title}":
        command     => "${middleware_home_dir}/Oracle_OAMWebGate1/webgate/ohs/tools/setup/InstallTools/EditHttpConf -w ${instance_id} -oh ${middleware_home_dir}/Oracle_OAMWebGate1",
        environment => ["LD_LIBRARY_PATH=${middleware_home_dir}/Oracle_WT1/lib",
                        "ORACLE_HOME=${middleware_home_dir}/Oracle_OAMWebGate1"],
        cwd         => "${middleware_home_dir}/Oracle_OAMWebGate1/webgate/ohs/tools/setup/InstallTools",
        path        => $exec_path,
        unless      => "grep -c '${instance_id}/webgate.conf' ${instance_id}/httpd.conf",
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => [Exec["Deploy webgate to ${instance_id}"],File["Copy rreg artifacts for ${instance_id}"],],
      }

      # after enabling a WebGate you need to bounce OHS
      exec { "Stop OHS instance ${title}":
        command   => "/bin/sh -c 'unset DISPLAY;${middleware_home_dir}/Oracle_WT1/instances/${instance_name}/bin/opmnctl stopall'",
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        logoutput => $log_output,
        require   => Exec["EditHttpConf to enable webgate ${title}"],
      }

      exec { "Start OHS instance ${title}":
        command   => "/bin/sh -c 'unset DISPLAY;${middleware_home_dir}/Oracle_WT1/instances/${instance_name}/bin/opmnctl startall'",
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        logoutput => $log_output,
        require   => Exec["Stop OHS instance ${title}"],
      }
    }
  }
}