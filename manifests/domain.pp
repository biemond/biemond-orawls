# == Define: orawls::domain
#
# setup a new weblogic domain
##
define orawls::domain (
  $version                               = hiera('wls_version'                   , 1111),  # 1036|1111|1211|1212|1213|1221
  $weblogic_home_dir                     = hiera('wls_weblogic_home_dir'), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir                   = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $jdk_home_dir                          = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $wls_domains_dir                       = hiera('wls_domains_dir'               , undef),
  $wls_apps_dir                          = hiera('wls_apps_dir'                  , undef),
  $domain_template                       = hiera('domain_template'               , 'standard'), # adf|adf_restricted|osb|osb_soa_bpm|osb_soa|soa|soa_bpm|bam|wc|wc_wcc_bpm|oud|ohs_standalone
  $bam_enabled                           = true,  #only for SOA Suite
  $b2b_enabled                           = false, #only for SOA Suite 12.1.3 with b2b
  $ess_enabled                           = false, #only for SOA Suite 12.1.3
  $owsm_enabled                          = false, #only for OSB domain_template on 10.3.6
  $domain_name                           = hiera('domain_name'),
  $development_mode                      = true,
  $adminserver_name                      = hiera('domain_adminserver'             , 'AdminServer'),
  $adminserver_machine_name              = hiera('domain_adminserver_machine_name', 'LocalMachine'),
  $adminserver_address                   = hiera('domain_adminserver_address'     , undef),
  $adminserver_port                      = hiera('domain_adminserver_port'        , 7001),
  $adminserver_ssl_port                  = undef,
  $adminserver_listen_on_all_interfaces  = false,  # for docker etc
  $java_arguments                        = hiera('domain_java_arguments'         , {}),         # java_arguments = { "ADM" => "...", "OSB" => "...", "SOA" => "...", "BAM" => "..."}
  $nodemanager_address                   = undef,
  $nodemanager_port                      = hiera('domain_nodemanager_port'       , 5556),
  $nodemanager_secure_listener           = true,
  $weblogic_user                         = hiera('wls_weblogic_user'             , 'weblogic'),
  $weblogic_password                     = hiera('domain_wls_password'),
  $nodemanager_username                  = undef, # When not specified, it'll use the weblogic_user
  $nodemanager_password                  = undef, # When not specified, it'll use the weblogic_password
  $domain_password                       = undef, # When not specified, it'll use the weblogic_password
  $jsse_enabled                          = hiera('wls_jsse_enabled'              , false),
  $webtier_enabled                       = false,
  $os_user                               = hiera('wls_os_user'), # oracle
  $os_group                              = hiera('wls_os_group'), # dba
  $download_dir                          = hiera('wls_download_dir'), # /data/install
  $log_dir                               = hiera('wls_log_dir'                   , undef), # /data/logs
  $log_output                            = false, # true|false
  $repository_database_url               = hiera('repository_database_url'       , undef), #jdbc:oracle:thin:@192.168.50.5:1521:XE
  $rcu_database_url                      = undef,                                      #localhost:1521:XE"
  $repository_prefix                     = hiera('repository_prefix'             , 'DEV'),
  $repository_password                   = hiera('repository_password'           , 'Welcome01'),
  $repository_sys_user                   = 'sys',
  $repository_sys_password               = undef,
  $custom_trust                          = hiera('wls_custom_trust'              , false),
  $trust_keystore_file                   = hiera('wls_trust_keystore_file'       , undef),
  $trust_keystore_passphrase             = hiera('wls_trust_keystore_passphrase' , undef),
  $custom_identity                       = false,
  $custom_identity_keystore_filename     = undef,
  $custom_identity_keystore_passphrase   = undef,
  $custom_identity_alias                 = undef,
  $custom_identity_privatekey_passphrase = undef,
  $create_rcu                            = hiera('create_rcu', true),
  $ohs_standalone_listen_address         = undef,
  $ohs_standalone_listen_port            = undef,
  $ohs_standalone_ssl_listen_port        = undef,
  $wls_domains_file						 = $override_wls_domains_file,
)
{
  if ( $wls_domains_file == undef or $wls_domains_file == '' ){
	$wls_domains_file_location = '/etc/wls_domains.yaml'
  } else {
	$wls_domains_file_location = $wls_domains_file
  }
  
  if ( $wls_domains_dir == undef or $wls_domains_dir == '' ) {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  if ( $wls_apps_dir == undef or $wls_apps_dir == '') {
    $apps_dir = "${middleware_home_dir}/user_projects/applications"
  } else {
    $apps_dir =  $wls_apps_dir
  }

  $domain_dir = "${domains_dir}/${domain_name}"

  # check if the domain already exists
  $found = domain_exists($domain_dir)

  if $found == undef {
    $continue = true
  } else {
    if ($found) {
      $continue = false
    } else {
      notify { "orawls::domain ${title} ${domain_dir} ${version} does not exists": }
      $continue = true
    }
  }

  if ($continue) {
    if ( $version == 1036 or $version == 1111 ) {
      $template          = "${weblogic_home_dir}/common/templates/domains/wls.jar"
      $templateWS        = "${weblogic_home_dir}/common/templates/applications/wls_webservice.jar"
      $templateJaxWS     = "${weblogic_home_dir}/common/templates/applications/wls_webservice_jaxws.jar"

      $templateEM        = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.em_11_1_1_0_0_template.jar"
      $templateJRF       = "${middleware_home_dir}/oracle_common/common/templates/applications/jrf_template_11.1.1.jar"
      $templateApplCore  = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.applcore.model.stub.11.1.1_template.jar"
      $templateWSMPM     = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.wsmpm_template_11.1.1.jar"

      $templateOSB          = "${middleware_home_dir}/Oracle_OSB1/common/templates/applications/wlsb.jar"
      $templateOWSM         = "${middleware_home_dir}/Oracle_OSB1/common/templates/applications/wlsb_owsm.jar"
      $templateSOAAdapters  = "${middleware_home_dir}/Oracle_OSB1/common/templates/applications/oracle.soa.common.adapters_template_11.1.1.jar"
      $templateSOA          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.soa_template_11.1.1.jar"
      $templateBPM          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.bpm_template_11.1.1.jar"
      $templateBAM          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.bam_template_11.1.1.jar"

    } elsif $version == 1112 {
      $template          = "${weblogic_home_dir}/common/templates/domains/wls.jar"
      $templateWS        = "${weblogic_home_dir}/common/templates/applications/wls_webservice.jar"

      $templateEM        = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.em_11_1_1_0_0_template.jar"
      $templateJRF       = "${middleware_home_dir}/oracle_common/common/templates/applications/jrf_template_11.1.1.jar"
      $templateApplCore  = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.applcore.model.stub.11.1.1_template.jar"
      $templateWSMPM     = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.wsmpm_template_11.1.1.jar"

      $templateOIM       = "${middleware_home_dir}/Oracle_IDM1/common/templates/applications/oracle.oim_11.1.2.0.0_template.jar"
      $templateOAM       = "${middleware_home_dir}/Oracle_IDM1/common/templates/applications/oracle.oam_ds_11.1.2.0.0_template.jar"

      $templateOUD       = "${middleware_home_dir}/Oracle_OUD1/common/templates/applications/oracle.odsm_11.1.1.5.0_template.jar"

      $templateOSB          = "${middleware_home_dir}/Oracle_OSB1/common/templates/applications/wlsb.jar"
      $templateSOAAdapters  = "${middleware_home_dir}/Oracle_OSB1/common/templates/applications/oracle.soa.common.adapters_template_11.1.1.jar"
      $templateSOA          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.soa_template_11.1.1.jar"
      $templateBPM          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.bpm_template_11.1.1.jar"
      $templateBAM          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.bam_template_11.1.1.jar"

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

      if $domain_template == 'ohs_standalone' {
        $templateOHS     = "${middleware_home_dir}/ohs/common/templates/wls/ohs_standalone_template_12.1.2.jar"
      }
      else {
        $templateOHS     = "${middleware_home_dir}/ohs/common/templates/wls/ohs_managed_template_12.1.2.jar"
      }
      $templateEMWebTier = "${middleware_home_dir}/em/common/templates/wls/oracle.em_webtier_template_12.1.2.jar"

    } elsif $version == 1213 {
      $template          = "${weblogic_home_dir}/common/templates/wls/wls.jar"
      $templateWS        = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.wls-webservice-template_12.1.3.jar"
      $templateJaxWS     = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.wls-webservice-jaxws-template_12.1.3.jar"
      $templateSoapJms   = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.wls-webservice-soapjms-template_12.1.3.jar"
      $templateCoherence = "${weblogic_home_dir}/common/templates/wls/wls_coherence_template_12.1.3.jar"

      $templateEM        = "${middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template_12.1.3.jar"
      $templateJRF       = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.jrf_template_12.1.3.jar"
      $templateApplCore  = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.applcore.model.stub.1.0.0_template.jar"
      $templateWSMPM     = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.wsmpm_template_12.1.3.jar"

      if $domain_template == 'ohs_standalone' {
        $templateOHS     = "${middleware_home_dir}/ohs/common/templates/wls/ohs_standalone_template_12.1.3.jar"
      }
      else {
        $templateOHS     = "${middleware_home_dir}/ohs/common/templates/wls/ohs_managed_template_12.1.3.jar"
      }
      $templateEMWebTier = "${middleware_home_dir}/em/common/templates/wls/oracle.em_webtier_template_12.1.3.jar"
      $templateESS_EM    = "${middleware_home_dir}/em/common/templates/wls/oracle.em_ess_template_12.1.3.jar"
      $templateESS       = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.ess.basic_template_12.1.3.jar"

      $templateOSB          = "${middleware_home_dir}/osb/common/templates/wls/oracle.osb_template_12.1.3.jar"
      $templateSOA          = "${middleware_home_dir}/soa/common/templates/wls/oracle.soa_template_12.1.3.jar"
      $templateBPM          = "${middleware_home_dir}/soa/common/templates/wls/oracle.bpm_template_12.1.3.jar"
      $templateBAM          = "${middleware_home_dir}/soa/common/templates/wls/oracle.bam.server_template_12.1.3.jar"
      $templateB2B          = "${middleware_home_dir}/soa/common/templates/wls/oracle.soa.b2b_template_12.1.3.jar"
      $templateHEALTH       = "${middleware_home_dir}/soa/common/templates/wls/oracle.soa.healthcare_template_12.1.3.jar"

    } elsif $version == 1221 {
      $template          = "${weblogic_home_dir}/common/templates/wls/wls.jar"
      $templateWS        = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.wls-webservice-template.jar"
      $templateJaxWS     = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.wls-webservice-jaxws-template.jar"
      $templateSoapJms   = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.wls-webservice-soapjms-template.jar"
      $templateCoherence = "${weblogic_home_dir}/common/templates/wls/wls_coherence_template.jar"

      if $domain_template == 'adf_restricted' {
        $templateEM        = "${middleware_home_dir}/em/common/templates/wls/oracle.em_wls_restricted_template.jar"
        $templateJRF       = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.jrf_restricted_template.jar"
        $templateOHS       = "${middleware_home_dir}/ohs/common/templates/wls/ohs_jrf_restricted_template.jar"
        $restricted        = true
      } else {
        $templateEM        = "${middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template.jar"
        $templateJRF       = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.jrf_template.jar"
        if $domain_template == 'ohs_standalone' {
          $templateOHS     = "${middleware_home_dir}/ohs/common/templates/wls/ohs_standalone_template.jar"
        }
        else {
          $templateOHS     = "${middleware_home_dir}/ohs/common/templates/wls/ohs_managed_template.jar"
        }
      }

      $templateApplCore  = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.applcore.model.stub_template.jar"
      $templateWSMPM     = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.wsmpm_template.jar"

      $templateEMWebTier = "${middleware_home_dir}/em/common/templates/wls/oracle.em_webtier_template.jar"
      $templateESS_EM    = "${middleware_home_dir}/em/common/templates/wls/oracle.em_ess_template.jar"
      $templateESS       = "${middleware_home_dir}/oracle_common/common/templates/wls/oracle.ess.basic_template.jar"

      $templateOSB          = "${middleware_home_dir}/osb/common/templates/wls/oracle.osb_template.jar"
      $templateSOA          = "${middleware_home_dir}/soa/common/templates/wls/oracle.soa_template.jar"
      $templateBPM          = "${middleware_home_dir}/soa/common/templates/wls/oracle.bpm_template.jar"
      $templateBAM          = "${middleware_home_dir}/soa/common/templates/wls/oracle.bam.server_template.jar"
      $templateB2B          = "${middleware_home_dir}/soa/common/templates/wls/oracle.soa.b2b_template.jar"
      $templateHEALTH       = "${middleware_home_dir}/soa/common/templates/wls/oracle.soa.healthcare_template.jar"

    } else {
      $template          = "${weblogic_home_dir}/common/templates/domains/wls.jar"
      $templateWS        = "${weblogic_home_dir}/common/templates/applications/wls_webservice.jar"

      $templateEM        = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.em_11_1_1_0_0_template.jar"
      $templateJRF       = "${middleware_home_dir}/oracle_common/common/templates/applications/jrf_template_11.1.1.jar"
      $templateJaxWS     = "${middleware_home_dir}/oracle_common/common/templates/applications/wls_webservice_jaxws.jar"
      $templateApplCore  = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.applcore.model.stub.11.1.1_template.jar"
      $templateWSMPM     = "${middleware_home_dir}/oracle_common/common/templates/applications/oracle.wsmpm_template_11.1.1.jar"

      $templateOSB          = "${middleware_home_dir}/Oracle_OSB1/common/templates/applications/wlsb.jar"
      $templateSOAAdapters  = "${middleware_home_dir}/Oracle_OSB1/common/templates/applications/oracle.soa.common.adapters_template_11.1.1.jar"
      $templateSOA          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.soa_template_11.1.1.jar"
      $templateBPM          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.bpm_template_11.1.1.jar"
      $templateBAM          = "${middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.bam_template_11.1.1.jar"
    }


    $templateSpaces       = "${middleware_home_dir}/Oracle_WC1/common/templates/applications/oracle.wc_spaces_template_11.1.1.jar"
    $templateBPMSpaces    = "${middleware_home_dir}/Oracle_WC1/common/templates/applications/oracle.bpm.spaces_template_11.1.1.jar"
    $templatePortlets     = "${middleware_home_dir}/Oracle_WC1/common/templates/applications/oracle.producer_apps_template_11.1.1.jar"
    $templatePagelet      = "${middleware_home_dir}/Oracle_WC1/common/templates/applications/oracle.pagelet-producer_template_11.1.1.jar"
    $templateDiscussion   = "${middleware_home_dir}/Oracle_WC1/common/templates/applications/oracle.owc_discussions_template_11.1.1.jar"

    $templateUCM          = "${middleware_home_dir}/Oracle_WCC1/common/templates/applications/oracle.ucm.cs_template_11.1.1.jar"

    if $domain_template != 'ohs_standalone' {
      $templateFile = 'orawls/domains/domain.py.erb'
    }

    if $domain_template == 'ohs_standalone' {
      if ( $version == 1212 or $version == 1213 or $version == 1221) {
        $extensionsTemplateFile = undef
        $wlstPath       = "${middleware_home_dir}/ohs/common/bin"
        $templateFile = 'orawls/ohs/domain.py.erb'
      }
      else {
        fail("OHS Standalone domain configuration currently works only with version 12.1.2, 12.1.3 or 12.1.2. Version ${version} not supported.")
      }
    }
    elsif $domain_template == 'standard' {
      $extensionsTemplateFile = undef
      $wlstPath       = "${weblogic_home_dir}/common/bin"

    } elsif $domain_template == 'osb' {
      $extensionsTemplateFile = 'orawls/domains/extensions/osb_template.py.erb'

      if ( $version == 1221 ) {
        $wlstPath      = "${middleware_home_dir}/oracle_common/common/bin"
      }
      elsif ( $version == 1213 ) {
        $wlstPath      = "${middleware_home_dir}/osb/common/bin"
      }
      else {
        $wlstPath      = "${middleware_home_dir}/Oracle_OSB1/common/bin"
      }

    } elsif $domain_template == 'osb_soa' or $domain_template == 'osb_soa_bpm' {
      $extensionsTemplateFile = 'orawls/domains/extensions/soa_osb_template.py.erb'

      if ( $version == 1221 ) {
        $wlstPath      = "${middleware_home_dir}/oracle_common/common/bin"
      }
      elsif ( $version == 1213 ) {
        $wlstPath      = "${middleware_home_dir}/soa/common/bin"
      }
      else {
        $wlstPath      = "${middleware_home_dir}/Oracle_SOA1/common/bin"
      }
      if $domain_template == 'osb_soa' {
        $bpm           = false
      } elsif $domain_template == 'osb_soa_bpm'  {
        $bpm           = true
      }

    } elsif $domain_template == 'soa' or $domain_template == 'soa_bpm' {
      $extensionsTemplateFile = 'orawls/domains/extensions/soa_template.py.erb'

      if ( $version == 1221 ) {
        $wlstPath      = "${middleware_home_dir}/oracle_common/common/bin"
      }
      elsif ( $version == 1213 ) {
        $wlstPath      = "${middleware_home_dir}/soa/common/bin"
      }
      else {
        $wlstPath      = "${middleware_home_dir}/Oracle_SOA1/common/bin"
      }
      if $domain_template == 'soa' {
        $bpm           = false
      } elsif $domain_template == 'soa_bpm'  {
        $bpm           = true
      }

    } elsif $domain_template == 'bam' {
      $extensionsTemplateFile = 'orawls/domains/extensions/bam_template.py.erb'

      if ( $version == 1221 ) {
        $wlstPath      = "${middleware_home_dir}/oracle_common/common/bin"
      }
      elsif ( $version == 1213 ) {
        $wlstPath      = "${middleware_home_dir}/soa/common/bin"
      }
      else {
        $wlstPath      = "${middleware_home_dir}/Oracle_SOA1/common/bin"
      }

    } elsif ( $domain_template == 'adf' or $domain_template == 'adf_restricted' ) {
      $extensionsTemplateFile = 'orawls/domains/extensions/jrf_template.py.erb'

      $wlstPath      = "${middleware_home_dir}/oracle_common/common/bin"

    } elsif $domain_template == 'oim' {
      $extensionsTemplateFile = 'orawls/domains/extensions/oim_oam_template.py.erb'

      $wlstPath      = "${middleware_home_dir}/Oracle_IDM1/common/bin"

    } elsif $domain_template == 'oud' {
      $extensionsTemplateFile = 'orawls/domains/extensions/oud_template.py.erb'

      $wlstPath      = "${weblogic_home_dir}/common/bin"

    } elsif $domain_template == 'wc' {
      $extensionsTemplateFile = 'orawls/domains/extensions/wc_template.py.erb'

      if ( $version == 1221 ) {
        $wlstPath      = "${middleware_home_dir}/oracle_common/common/bin"
      }
      else {
        $wlstPath      = "${middleware_home_dir}/Oracle_WC1/common/bin"
      }
    } elsif $domain_template == 'wc_wcc_bpm' {
      $extensionsTemplateFile = 'orawls/domains/extensions/wc_wcc_template.py.erb'

      if ( $version == 1221 ) {
        $wlstPath      = "${middleware_home_dir}/oracle_common/common/bin"
      }
      else {
        $wlstPath      = "${middleware_home_dir}/Oracle_WCC1/common/bin"
      }
    } else {
      $extensionsTemplateFile = undef

      $wlstPath       = "${weblogic_home_dir}/common/bin"
    }

    $exec_path        = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"

    Exec {
      logoutput => $log_output,
    }

    if $log_dir == undef {
      $admin_nodemanager_log_dir = "${domain_dir}/servers/${adminserver_name}/logs"
      $nodeMgrLogDir             = "${domain_dir}/nodemanager/nodemanager.log"


      $osb_nodemanager_log_dir   = "${domain_dir}/servers/osb_server1/logs"
      $soa_nodemanager_log_dir   = "${domain_dir}/servers/soa_server1/logs"
      $bam_nodemanager_log_dir   = "${domain_dir}/servers/bam_server1/logs"
      $ess_nodemanager_log_dir   = "${domain_dir}/servers/ess_server1/logs"

      $oim_nodemanager_log_dir   = "${domain_dir}/servers/oim_server1/logs"
      $oam_nodemanager_log_dir   = "${domain_dir}/servers/oam_server1/logs"
      $bi_nodemanager_log_dir    = "${domain_dir}/servers/bi_server1/logs"

      $wcCollaboration_nodemanager_log_dir   = "${domain_dir}/servers/WC_Collaboration/logs"
      $wcPortlet_nodemanager_log_dir         = "${domain_dir}/servers/WC_Portlet/logs"
      $wcSpaces_nodemanager_log_dir          = "${domain_dir}/servers/WC_Spaces/logs"
      $umc_nodemanager_log_dir               = "${domain_dir}/servers/UCM_server1/logs"


    } else {
      $admin_nodemanager_log_dir = $log_dir
      $nodeMgrLogDir             = "${log_dir}/nodemanager_${domain_name}.log"

      $osb_nodemanager_log_dir   = $log_dir
      $soa_nodemanager_log_dir   = $log_dir
      $bam_nodemanager_log_dir   = $log_dir
      $ess_nodemanager_log_dir   = $log_dir

      $oim_nodemanager_log_dir   = $log_dir
      $oam_nodemanager_log_dir   = $log_dir
      $bi_nodemanager_log_dir    = $log_dir

      $wcCollaboration_nodemanager_log_dir   = $log_dir
      $wcPortlet_nodemanager_log_dir         = $log_dir
      $wcSpaces_nodemanager_log_dir          = $log_dir
      $umc_nodemanager_log_dir               = $log_dir


      # create all log folders
      if !defined(Exec["create ${log_dir} directory"]) {
        exec { "create ${log_dir} directory":
          command => "mkdir -p ${log_dir}",
          unless  => "test -d ${log_dir}",
          user    => $os_user,
          path    => $exec_path,
        }
      }

      if !defined(File[$log_dir]) {
        file { $log_dir:
          ensure  => directory,
          recurse => false,
          replace => false,
          require => Exec["create ${log_dir} directory"],
          mode    => '0775',
          owner   => $os_user,
          group   => $os_group,
        }
      }
    }

    # if !defined(File[$download_dir]) {
    #   file { $download_dir:
    #     ensure => directory,
    #     mode   => '0777',
    #   }
    # }

    # the utils.py used by the wlst
    if !defined(File["${download_dir}/utils.py"]) {
      file { "${download_dir}/utils.py":
        ensure  => present,
        path    => "${download_dir}/utils.py",
        content => template('orawls/domains/utils.py.erb'),
        replace => true,
        backup  => false,
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
        # require => File[$download_dir],
      }
    }

    if($extensionsTemplateFile) {
      file { "domain_extension.py ${domain_name} ${title}":
        ensure  => present,
        path    => "${download_dir}/domain_extension_${domain_name}.py",
        content => template($extensionsTemplateFile),
        replace => true,
        backup  => false,
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
        # require => File[$download_dir],
        before  => File["domain.py ${domain_name} ${title}"],
      }
    }

    # the domain.py used by the wlst
    file { "domain.py ${domain_name} ${title}":
      ensure  => present,
      path    => "${download_dir}/domain_${domain_name}.py",
      content => template($templateFile),
      replace => true,
      backup  => false,
      mode    => '0775',
      owner   => $os_user,
      group   => $os_group,
      require => File["${download_dir}/utils.py"],
    }

    if ( $domains_dir == "${middleware_home_dir}/user_projects/domains"){
      if !defined(File['weblogic_domain_folder']) {
          # check oracle install folder
          file { 'weblogic_domain_folder':
            ensure  => directory,
            path    => "${middleware_home_dir}/user_projects",
            recurse => false,
            replace => false,
            mode    => '0775',
            owner   => $os_user,
            group   => $os_group,
          }
        File['weblogic_domain_folder'] -> File[$domains_dir]
      }
    }

    if !defined(File[$domains_dir]) {
      # check oracle install folder
      file { $domains_dir:
        ensure  => directory,
        recurse => false,
        replace => false,
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
      }
    }

    if $apps_dir != undef {
      if !defined(File[$apps_dir]) {
        # check oracle install folder
        file { $apps_dir:
          ensure  => directory,
          recurse => false,
          replace => false,
          mode    => '0775',
          owner   => $os_user,
          group   => $os_group,
        }
      }
      # File[$apps_dir] -> Exec["execwlst ${domain_name} ${title}"]
    }

    # FMW RCU only for wls 12.1.2 or higher and when template is not standard
    if ( $version >= 1212 and $domain_template != 'standard' and $domain_template != 'adf_restricted' and $domain_template != 'ohs_standalone' ) {

      if ( $domain_template == 'adf' ) {
        $rcu_domain_template = 'adf'

      } elsif ( $domain_template in ['soa', 'osb', 'osb_soa_bpm', 'osb_soa', 'soa_bpm', 'bam'] ){
        $rcu_domain_template = 'soa'

      } elsif ($create_rcu == undef or $create_rcu == true) {
        fail('unkown domain_template for rcu with version 1212 or 1213')
      }

      if ( $create_rcu == undef or $create_rcu == true)
      {

        # only works for a 12c middleware home
        # creates RCU for ADF
        if ( $rcu_database_url == undefined or $repository_sys_password == undefined or $repository_password == undefined or $repository_prefix == undefined ){
          fail('Not all RCU parameters are provided')
        }

        orawls::utils::rcu{ "RCU_12c ${title}":
          version                     => $version,
          fmw_product                 => $rcu_domain_template,
          oracle_fmw_product_home_dir => "${middleware_home_dir}/oracle_common",
          jdk_home_dir                => $jdk_home_dir,
          os_user                     => $os_user,
          os_group                    => $os_group,
          download_dir                => $download_dir,
          rcu_action                  => 'create',
          rcu_jdbc_url                => $repository_database_url,
          rcu_database_url            => $rcu_database_url,
          rcu_sys_user                => $repository_sys_user,
          rcu_sys_password            => $repository_sys_password,
          rcu_prefix                  => $repository_prefix,
          rcu_password                => $repository_password,
          log_output                  => $log_output,
          before                      => Exec["execwlst ${domain_name} ${title}"],
        }
      }
    }

    # create domain
    exec { "execwlst ${domain_name} ${title}":
      command     => "${wlstPath}/wlst.sh domain_${domain_name}.py",
      environment => ["JAVA_HOME=${jdk_home_dir}"],
      unless      => "/usr/bin/test -e ${domain_dir}",
      creates     => $domain_dir,
      cwd         => $download_dir,
      require     => [File["domain.py ${domain_name} ${title}"],
                      File["${download_dir}/utils.py"],
                      File[$domains_dir],],
      timeout     => 0,
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
    }

    if($extensionsTemplateFile) {
      exec { "execwlst ${domain_name} extension ${title}":
        command     => "${wlstPath}/wlst.sh domain_extension_${domain_name}.py",
        environment => ["JAVA_HOME=${jdk_home_dir}"],
        cwd         => $download_dir,
        timeout     => 0,
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
        require     => [Exec["execwlst ${domain_name} ${title}"],
                        File["domain_extension.py ${domain_name} ${title}"],],
      }
    }

    yaml_setting { "domain ${title}":
      target  =>  $wls_domains_file_location,
      key     =>  "domains/${domain_name}",
      value   =>  $domain_dir,
      require =>  Exec["execwlst ${domain_name} ${title}"],
    }

    if ($domain_template == 'oim') {

      file { "${download_dir}/${title}psa_opss_upgrade.rsp":
        ensure  => present,
        content => template('orawls/oim/psa_opss_upgrade.rsp.erb'),
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
        backup  => false,
      }

      exec { "exec PSA OPSS store upgrade ${domain_name} ${title}":
        command => "${middleware_home_dir}/oracle_common/bin/psa -response ${download_dir}/${title}psa_opss_upgrade.rsp",
        require => [Exec["execwlst ${domain_name} ${title}"],
                    Exec["execwlst ${domain_name} extension ${title}"],
                    File["${download_dir}/${title}psa_opss_upgrade.rsp"],],
        timeout => 0,
        cwd     => $download_dir, # Added since psa binary saves and changes to current dir
        path    => $exec_path,
        user    => $os_user,
        group   => $os_group,
      }

      exec { "execwlst create OPSS store ${domain_name} ${title}":
        command     => "${wlstPath}/wlst.sh ${middleware_home_dir}/Oracle_IDM1/common/tools/configureSecurityStore.py -d ${domain_dir} -m create -c IAM -p ${repository_password}",
        environment => ["JAVA_HOME=${jdk_home_dir}"],
        require     => [Exec["execwlst ${domain_name} ${title}"],
                        Exec["execwlst ${domain_name} extension ${title}"],
                        Exec["exec PSA OPSS store upgrade ${domain_name} ${title}"],],
        timeout     => 0,
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
      }

      exec { "execwlst validate OPSS store ${domain_name} ${title}":
        command     => "${wlstPath}/wlst.sh ${middleware_home_dir}/Oracle_IDM1/common/tools/configureSecurityStore.py -d ${domain_dir} -m validate",
        environment => ["JAVA_HOME=${jdk_home_dir}"],
        require     => [Exec["execwlst ${domain_name} ${title}"],
                        Exec["execwlst ${domain_name} extension ${title}"],
                        Exec["execwlst create OPSS store ${domain_name} ${title}"]],
        timeout     => 0,
        path        => $exec_path,
        user        => $os_user,
        group       => $os_group,
      }

    }

    if $::kernel == 'SunOS' {

      if ($domain_template == 'osb' or
          $domain_template == 'osb_soa' or
          $domain_template == 'osb_soa_bpm'){

        exec { "setDebugFlagOnFalse ${domain_name} ${title}":
          command => "sed -e's/debugFlag=\"true\"/debugFlag=\"false\"/g' ${domain_dir}/bin/setDomainEnv.sh > /tmp/domain.tmp && mv /tmp/domain.tmp ${domain_dir}/bin/setDomainEnv.sh",
          onlyif  => "/bin/grep debugFlag=\"true\" ${domain_dir}/bin/setDomainEnv.sh | /usr/bin/wc -l",
          require => [Exec["execwlst ${domain_name} ${title}"],
                      Exec["execwlst ${domain_name} extension ${title}"],],
          path    => $exec_path,
          user    => $os_user,
          group   => $os_group,
        }

        exec { "setOSBDebugFlagOnFalse ${domain_name} ${title}":
          command => "sed -e's/ALSB_DEBUG_FLAG=\"true\"/ALSB_DEBUG_FLAG=\"false\"/g' ${domain_dir}/bin/setDomainEnv.sh > /tmp/domain2.tmp && mv /tmp/domain2.tmp ${domain_dir}/bin/setDomainEnv.sh",
          onlyif  => "/bin/grep ALSB_DEBUG_FLAG=\"true\" ${domain_dir}/bin/setDomainEnv.sh | /usr/bin/wc -l",
          require => Exec["setDebugFlagOnFalse ${domain_name} ${title}"],
          path    => $exec_path,
          user    => $os_user,
          group   => $os_group,
        }

        exec { "setDERBY_FLAGOnFalse ${domain_name} ${title}":
          command => "sed -e's/DERBY_FLAG=\"true\"/DERBY_FLAG=\"false\"/g' ${domain_dir}/bin/setDomainEnv.sh > /tmp/domain3.tmp && mv /tmp/domain3.tmp ${domain_dir}/bin/setDomainEnv.sh",
          onlyif  => "/bin/grep DERBY_FLAG=\"true\" ${domain_dir}/bin/setDomainEnv.sh | /usr/bin/wc -l",
          require => Exec["setOSBDebugFlagOnFalse ${domain_name} ${title}"],
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
          command => "sed -i -e's/debugFlag=\"true\"/debugFlag=\"false\"/g' ${domain_dir}/bin/setDomainEnv.sh",
          onlyif  => "/bin/grep debugFlag=\"true\" ${domain_dir}/bin/setDomainEnv.sh | /usr/bin/wc -l",
          require => [Exec["execwlst ${domain_name} ${title}"],
                      Exec["execwlst ${domain_name} extension ${title}"],],
          path    => $exec_path,
          user    => $os_user,
          group   => $os_group,
        }

        exec { "setOSBDebugFlagOnFalse ${domain_name} ${title}":
          command => "sed -i -e's/ALSB_DEBUG_FLAG=\"true\"/ALSB_DEBUG_FLAG=\"false\"/g' ${domain_dir}/bin/setDomainEnv.sh",
          onlyif  => "/bin/grep ALSB_DEBUG_FLAG=\"true\" ${domain_dir}/bin/setDomainEnv.sh | /usr/bin/wc -l",
          require => Exec["setDebugFlagOnFalse ${domain_name} ${title}"],
          path    => $exec_path,
          user    => $os_user,
          group   => $os_group,
        }

        exec { "setDERBY_FLAGOnFalse ${domain_name} ${title}":
          command => "sed -i -e's/DERBY_FLAG=\"true\"/DERBY_FLAG=\"false\"/g' ${domain_dir}/bin/setDomainEnv.sh",
          onlyif  => "/bin/grep DERBY_FLAG=\"true\" ${domain_dir}/bin/setDomainEnv.sh | /usr/bin/wc -l",
          require => Exec["setOSBDebugFlagOnFalse ${domain_name} ${title}"],
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

    if($extensionsTemplateFile) {
      exec { "domain.py ${domain_name} extension ${title}":
        command => "rm ${download_dir}/domain_extension_${domain_name}.py",
        require => Exec["execwlst ${domain_name} extension ${title}"],
        path    => $exec_path,
        user    => $os_user,
        group   => $os_group,
      }
    }
  }
}
