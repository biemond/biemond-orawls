# == Define: orawls::domain
#
# setup a new weblogic domain
##
define orawls::domain (
  $version                    = hiera('wls_version'               , 1111),  # 1036|1111|1211|1212
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'     , undef), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir'   , undef), # /opt/oracle/middleware11gR1
  $jdk_home_dir               = hiera('wls_jdk_home_dir'          , undef), # /usr/java/jdk1.7.0_45
  $domain_template            = "standard",                                 # adf|osb|osb_soa_bpm|osb_soa|soa|soa_bpm
  $domain_name                = hiera('domain_name'               , undef),
  $development_mode           = true,
  $adminserver_name           = hiera('domain_adminserver'        , "AdminServer"),
  $adminserver_address        = hiera('domain_adminserver_address', "localhost"),
  $adminserver_port           = hiera('domain_adminserver_port'   , 7001),
  $nodemanager_port           = hiera('domain_nodemanager_port'   , 5556),
  $weblogic_user              = hiera('wls_weblogic_user'         , "weblogic"),
  $weblogic_password          = hiera('domain_wls_password'       , undef),
  $os_user                    = hiera('wls_os_user'               , undef), # oracle
  $os_group                   = hiera('wls_os_group'              , undef), # dba
  $download_dir               = hiera('wls_download_dir'          , undef), # /data/install
  $log_dir                    = hiera('wls_log_dir'               , undef), # /data/logs
  $log_output                 = false, # true|false
  $repository_database_url    = hiera('repository_database_url'   , undef), #jdbc:oracle:thin:@192.168.50.5:1521:XE
  $repository_prefix          = hiera('repository_prefix'         , "DEV"),
  $repository_password        = hiera('repository_password'       , "Welcome01"),
)
{

  if $::override_weblogic_domain_folder == undef {
    $domain_dir = "${middleware_home_dir}/user_projects/domains"
    $app_dir    = "${middleware_home_dir}/user_projects/applications"
  } else {
    $domain_dir = "${::override_weblogic_domain_folder}/domains"
    $app_dir    = "${::override_weblogic_domain_folder}/applications"
  }

  # check if the domain already exists
  $found = domain_exists("${domain_dir}/${domain_name}", $version, $domain_dir)

  if $found == undef {
    $continue = true
  } else {
    if ($found) {
      $continue = false
    } else {
      notify { "orawls::domain ${title} ${domain_dir}/${domain_name} ${version} does not exists": }
      $continue = true
    }
  }

  if ($continue) {
    if ( $version == 1036 or $version == 1111 ) {
      $template          = "${weblogic_home_dir}/common/templates/domains/wls.jar"
      $templateWS        = "${weblogic_home_dir}/common/templates/applications/wls_webservice.jar"

      $templateEM        = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.em_11_1_1_0_0_template.jar"
      $templateJRF       = "${middleware_home_dir}/oracle_common/common/templates/applications/jrf_template_11.1.1.jar"
      $templateApplCore  = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.applcore.model.stub.11.1.1_template.jar"
      $templateWSMPM     = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.wsmpm_template_11.1.1.jar"

    } elsif $version == 1121 {
      $template          = "${weblogic_home_dir}/common/templates/domains/wls.jar"
      $templateWS        = "${weblogic_home_dir}/common/templates/applications/wls_webservice.jar"

      $templateEM        = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.em_11_1_1_0_0_template.jar"
      $templateJRF       = "${middleware_home_dir}/oracle_common/common/templates/applications/jrf_template_11.1.1.jar"
      $templateApplCore  = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.applcore.model.stub.11.1.1_template.jar"
      $templateWSMPM     = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.wsmpm_template_11.1.1.jar"

      $templateOIM       = "${middleware_home_dir}/Oracle_IDM1/common/templates/applications/oracle.oim_11.1.2.0.0_template.jar"
      $templateOAM       = "${middleware_home_dir}/Oracle_IDM1/common/templates/applications/oracle.oam_ds_11.1.2.0.0_template.jar"

    } elsif $version == 1212 {
      $template          = "${weblogic_home_dir}/common/templates/wls/wls.jar"
      $templateWS        = "${weblogic_home_dir}/common/templates/wls/wls_webservice.jar"
      $templateJaxWS     = "${weblogic_home_dir}/common/templates/wls/wls_webservice_jaxws.jar"
      $templateSoapJms   = "${weblogic_home_dir}/common/templates/wls/wls_webservice_soapjms.jar"
      $templateCoherence = "${weblogic_home_dir}/common/templates/wls/wls_coherence.jar"

      $templateEM        = "${middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template_12.1.2.jar"
      $templateJRF       = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.jrf_template_12.1.2.jar"
      $templateApplCore  = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.applcore.model.stub.12.1.3_template.jar"
      $templateWSMPM     = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.wsmpm_template_12.1.2.jar"


    } else {
      $template          = "${weblogic_home_dir}/common/templates/domains/wls.jar"
      $templateWS        = "${weblogic_home_dir}/common/templates/applications/wls_webservice.jar"

      $templateEM        = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.em_11_1_1_0_0_template.jar"
      $templateJRF       = "${middleware_home_dir}/oracle_common/common/templates/applications/jrf_template_11.1.1.jar"
      $templateJaxWS     = "${middleware_home_dir}/oracle_common/common/templates/applications/wls_webservice_jaxws.jar"
      $templateApplCore  = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.applcore.model.stub.11.1.1_template.jar"
      $templateWSMPM     = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.wsmpm_template_11.1.1.jar"
    }

    $templateOSB          = "${middleware_home_dir}/Oracle_OSB1/common/templates/applications/wlsb.jar"
    $templateSOAAdapters  = "${middleware_home_dir}/Oracle_OSB1/common/templates/applications/oracle.soa.common.adapters_template_11.1.1.jar"

    $templateSOA          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.soa_template_11.1.1.jar"
    $templateBPM          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.bpm_template_11.1.1.jar"
    $templateBAM          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.bam_template_11.1.1.jar"

    $templateSpaces       = "${middleware_home_dir}/Oracle_WC1/common/templates/applications/oracle.wc_spaces_template_11.1.1.jar"
    $templateBPMSpaces    = "${middleware_home_dir}/Oracle_WC1/common/templates/applications/oracle.bpm.spaces_template_11.1.1.jar"
    $templatePortlets     = "${middleware_home_dir}/Oracle_WC1/common/templates/applications/oracle.producer_apps_template_11.1.1.jar"
    $templatePagelet      = "${middleware_home_dir}/Oracle_WC1/common/templates/applications/oracle.pagelet-producer_template_11.1.1.jar"
    $templateDiscussion   = "${middleware_home_dir}/Oracle_WC1/common/templates/applications/oracle.owc_discussions_template_11.1.1.jar"

    $templateUCM          = "${middleware_home_dir}/Oracle_WCC1/common/templates/applications/oracle.ucm.cs_template_11.1.1.jar"


    if $domain_template == 'standard' {
      $templateFile   = "orawls/domains/domain.py.erb"
      $wlstPath       = "${weblogic_home_dir}/common/bin"

    } elsif $domain_template == 'osb' {
      $templateFile  = "orawls/domains/domain_osb.py.erb"
      $wlstPath      = "${middleware_home_dir}/Oracle_OSB1/common/bin"

    } elsif $domain_template == 'osb_soa' or $domain_template == 'osb_soa_bpm' {
      $templateFile  = "orawls/domains/domain_osb_soa_bpm.py.erb"
      $wlstPath      = "${middleware_home_dir}/Oracle_SOA1/common/bin"
      if $domain_template == 'osb_soa' {
        $bpm           = false
      } elsif $domain_template == 'osb_soa_bpm'  {
        $bpm           = true
      }

    } elsif $domain_template == 'soa' or $domain_template == 'soa_bpm' {
      $templateFile  = "orawls/domains/domain_soa_bpm.py.erb"
      $wlstPath      = "${middleware_home_dir}/Oracle_SOA1/common/bin"
      if $domain_template == 'soa' {
        $bpm           = false
      } elsif $domain_template == 'soa_bpm'  {
        $bpm           = true
      }

    } elsif $domain_template == 'adf' {
      $templateFile  = "orawls/domains/domain_adf.py.erb"
      $wlstPath      = "${middleware_home_dir}/oracle_common/common/bin"

    } else {
      $templateFile   = "orawls/domains/domain.py.erb"
      $wlstPath       = "${weblogic_home_dir}/common/bin"
    }

    $exec_path        = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"
    $nodeMgrMachine   = "UnixMachine"

    Exec {
      logoutput => $log_output,
    }

    if $log_dir == undef {
      $admin_nodemanager_log_dir = "${domain_dir}/${domain_name}/servers/${adminserver_name}/logs"
      $nodemanager_log_dir       = "${domain_dir}/${domain_name}/nodemanager/nodemanager.log"

      $osb_nodemanager_log_dir   = "${domain_dir}/${domain_name}/servers/osb_server1/logs"
      $soa_nodemanager_log_dir   = "${domain_dir}/${domain_name}/servers/soa_server1/logs"
      $bam_nodemanager_log_dir   = "${domain_dir}/${domain_name}/servers/bam_server1/logs"


    } else {
      $admin_nodemanager_log_dir = $log_dir
      $nodeMgrLogDir             = "${log_dir}/nodemanager_${domain_name}.log"

      $osb_nodemanager_log_dir   = $log_dir
      $soa_nodemanager_log_dir   = $log_dir
      $bam_nodemanager_log_dir   = $log_dir


      # create all log folders
      if !defined(Exec["create ${log_dir} directory"]) {
        exec { "create ${log_dir} directory":
          command => "mkdir -p ${log_dir}",
          unless  => "test -d ${log_dir}",
          user    => 'root',
          path    => $exec_path,
        }
      }

      if !defined(File[$log_dir]) {
        file { $log_dir:
          ensure  => directory,
          recurse => false,
          replace => false,
          require => Exec["create ${log_dir} directory"],
          mode    => 0775,
          owner   => $os_user,
          group   => $os_group,
        }
      }
    }

    # the domain.py used by the wlst
    file { "domain.py ${domain_name} ${title}":
      path    => "${download_dir}/domain_${domain_name}.py",
      content => template($templateFile),
      ensure  => present,
      replace => true,
      backup  => false,
      mode    => 0775,
      owner   => $os_user,
      group   => $os_group,
    }

    if $::override_weblogic_domain_folder == undef {
      # make the default domain folders
      if !defined(File["weblogic_domain_folder"]) {
        # check oracle install folder
        file { "weblogic_domain_folder":
          path    => "${middleware_home_dir}/user_projects",
          ensure  => directory,
          recurse => false,
          replace => false,
          mode    => 0775,
          owner   => $os_user,
          group   => $os_group,
        }
      }
    } else {
      # make override domain folders

      if !defined(File["weblogic_domain_folder"]) {
        # check oracle install folder
        file { "weblogic_domain_folder":
          path    => $::override_weblogic_domain_folder,
          ensure  => directory,
          recurse => false,
          replace => false,
          mode    => 0775,
          owner   => $os_user,
          group   => $os_group,
        }
      }
    }

    if !defined(File[$domain_dir]) {
      # check oracle install folder
      file { $domain_dir:
        ensure  => directory,
        recurse => false,
        replace => false,
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
        require => File["weblogic_domain_folder"],
      }
    }

    if !defined(File[$app_dir]) {
      # check oracle install folder
      file { $app_dir:
        ensure  => directory,
        recurse => false,
        replace => false,
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
        require => File["weblogic_domain_folder"],
      }
    }

    # create domain
    exec { "execwlst ${domain_name} ${title}":
      command     => "${wlstPath}/wlst.sh ${download_dir}/domain_${domain_name}.py",
      environment => ["JAVA_HOME=${jdk_home_dir}"],
      unless      => "/usr/bin/test -e ${domain_dir}/${domain_name}",
      creates     => "${domain_dir}/${domain_name}",
      require     => [
        File["domain.py ${domain_name} ${title}"],
        File[$domain_dir],
        File[$app_dir]],
      timeout     => 0,
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
    }

    if $::kernel == "SunOS" {


      if ($domain_template == 'osb' or
          $domain_template == 'osb_soa' or
          $domain_template == 'osb_soa_bpm'){

	      exec { "setDebugFlagOnFalse ${domain_name} ${title}":
	        command => "sed -e's/debugFlag=\"true\"/debugFlag=\"false\"/g' ${domain_dir}/${domain_name}/bin/setDomainEnv.sh > /tmp/domain.tmp && mv /tmp/domain.tmp ${domain_dir}/${domain_name}/bin/setDomainEnv.sh",
	        onlyif  => "/bin/grep debugFlag=\"true\" ${domain_dir}/${domain_name}/bin/setDomainEnv.sh | /usr/bin/wc -l",
	        require => Exec["execwlst ${domain_name} ${title}"],
	        path    => $exec_path,
	        user    => $os_user,
	        group   => $os_group,
	      }

        exec { "setOSBDebugFlagOnFalse ${domain_name} ${title}":
          command => "sed -e's/ALSB_DEBUG_FLAG=\"true\"/ALSB_DEBUG_FLAG=\"false\"/g' ${domain_dir}/${domain_name}/bin/setDomainEnv.sh > /tmp/domain2.tmp && mv /tmp/domain2.tmp ${domain_dir}/${domain_name}/bin/setDomainEnv.sh",
          onlyif  => "/bin/grep ALSB_DEBUG_FLAG=\"true\" ${domain_dir}/${domain_name}/bin/setDomainEnv.sh | /usr/bin/wc -l",
          require => Exec["setDebugFlagOnFalse ${domain_name} ${title}"],
          path    => $exec_path,
          user    => $os_user,
          group   => $os_group,
        }
      }

    } else {


      if ($domain_template == 'osb' or
          $domain_template == 'osb_soa' or
          $domain_template == 'osb_soa_bpm'){

	      exec { "setDebugFlagOnFalse ${domain_name} ${title}":
	        command => "sed -i -e's/debugFlag=\"true\"/debugFlag=\"false\"/g' ${domain_dir}/${domain_name}/bin/setDomainEnv.sh",
	        onlyif  => "/bin/grep debugFlag=\"true\" ${domain_dir}/${domain_name}/bin/setDomainEnv.sh | /usr/bin/wc -l",
	        require => Exec["execwlst ${domain_name} ${title}"],
	        path    => $exec_path,
	        user    => $os_user,
	        group   => $os_group,
	      }

        exec { "setOSBDebugFlagOnFalse ${domain_name} ${title}":
          command => "sed -i -e's/ALSB_DEBUG_FLAG=\"true\"/ALSB_DEBUG_FLAG=\"false\"/g' ${domain_dir}/${domain_name}/bin/setDomainEnv.sh",
          onlyif  => "/bin/grep ALSB_DEBUG_FLAG=\"true\" ${domain_dir}/${domain_name}/bin/setDomainEnv.sh | /usr/bin/wc -l",
          require => Exec["setDebugFlagOnFalse ${domain_name} ${title}"],
          path    => $exec_path,
          user    => $os_user,
          group   => $os_group,
        }
      }
    }

    exec { "domain.py ${domain_name} ${title}":
      command => "rm ${download_dir}/domain_${domain_name}.py",
      require => Exec["execwlst ${domain_name} ${title}"],
      path    => $exec_path,
      user    => $os_user,
      group   => $os_group,
    }

    $nodeMgrHome = "${domain_dir}/${domain_name}/nodemanager"
    $listenPort   = $nodemanager_port

    # set our 12.1.2 nodemanager properties
    if ($version == 1212) {
      file { "nodemanager.properties ux 1212 ${title}":
        path    => "${nodeMgrHome}/nodemanager.properties",
        ensure  => present,
        replace => true,
        content => template("orawls/nodemgr/nodemanager.properties_1212.erb"),
        require => Exec["execwlst ${domain_name} ${title}"],
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
      }
    }
  }
}
