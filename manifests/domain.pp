#
# domain define
#
# setup a new weblogic domain
#
# @example standard domain example
#   orawls::domain{'Wls1221':
#     domain_template                      => "standard",
#     domain_name                          => "Wls1221",
#     development_mode                     => false,
#     adminserver_address                  => '10.10.10.10',
#     adminserver_listen_on_all_interfaces => true,
#     adminserver_port                     => 7101,
#     nodemanager_port                     => 5557,
#     nodemanager_secure_listener          => false,
#     weblogic_password                    => weblogic1',
#     jsse_enabled                         => true,
#     log_dir                              => '/var/log/weblogic',
#     java_arguments                       => { 'ADM' =>  "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"},
#   }
#
#   orawls::domain{'Wls1221':
#     domain_template                       => "standard",
#     domain_name                           => "Wls1221",
#     development_mode                      => false,
#     adminserver_address                   => '10.10.10.10',
#     adminserver_ssl_port                  => 7002,
#     adminserver_port                      => 7001,
#     nodemanager_port                      => 5555,
#     weblogic_password                     => weblogic1',
#     jsse_enabled                          => true,
#     log_dir                               => '/var/log/weblogic',
#     custom_trust                          => true,
#     trust_keystore_file                   => '/vagrant/trust.jks',
#     trust_keystore_passphrase             => 'welcome',
#     custom_identity                       => true, 
#     custom_identity_keystore_filename     => '/vagrant/identity_admin.jks',
#     custom_identity_keystore_passphrase   => 'welcome',
#     custom_identity_alias                 => 'admin',
#     custom_identity_privatekey_passphrase => 'welcome',
#   }
#  
# @param version used weblogic software like 1036
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
# @param custom_identity have your own custom identity keystore
# @param custom_identity_keystore_filename full path to the custom identity keystore
# @param custom_identity_keystore_passphrase password of the custom identity keystore
# @param custom_identity_alias private key alias inside the custom identity keystore
# @param custom_identity_privatekey_passphrase private key password inside the custom identity keystore
# @param repository_prefix the used RCU prefix
# @param repository_database_url the JDBC url of the RCU database
# @param repository_password the password of the RCU schemas
# @param adminserver_name WebLogic AdminServer name
# @param nodemanager_port the port number of the used NodeManager
# @param bam_enabled BAM enabled on SOA SUITE
# @param owsm_enabled OWSM enabled
# @param b2b_enabled B2B enabled
# @param ess_enabled ESS enabled on SOA SUITE
# @param wls_apps_dir root directory for all the domain apps
# @param domain_template which domain extension to use
# @param development_mode WebLogic domain created in development
# @param adminserver_machine_name the localmachine name of the adminserver
# @param adminserver_ssl_port the ssl port of the adminserver
# @param adminserver_listen_on_all_interfaces adminserver listen on all VM interfaces
# @param java_arguments override the server argument of the managed servers created by the domain creation
# @param nodemanager_secure_listener use nodemanager in secure mode 
# @param nodemanager_username the username of the nodemanager
# @param nodemanager_password the password of the nodemanager
# @param domain_password the domain password
# @param webtier_enabled webtier template extension add to the domain
# @param rcu_database_url the rcu database url
# @param repository_sys_user the rcu sys username
# @param repository_sys_password the rcu sys passoword
# @param log_dir the full path to the log directory
# @param create_rcu do a RCU repository creation when it is necessary
# @param ohs_standalone_listen_address
# @param ohs_standalone_listen_port
# @param ohs_standalone_ssl_listen_port
# @param wls_domains_file the localtion where local domains are stored
# @param puppet_os_user the username under puppet should be executed
# @param create_default_coherence_cluster option to skip the coherence cluster template be added to the domain
#
define orawls::domain (
  Integer $version                                        = $::orawls::weblogic::version,
  String $weblogic_home_dir                               = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir,
  String $jdk_home_dir                                    = $::orawls::weblogic::jdk_home_dir,
  Optional[String] $wls_domains_dir                       = $::orawls::weblogic::wls_domains_dir,
  Optional[String] $wls_apps_dir                          = $::orawls::weblogic::wls_apps_dir,
  String $domain_template                                 = 'standard', # adf|adf_restricted|osb|osb_soa_bpm|osb_soa|soa|soa_bpm|bam|wc|wc_wcc_bpm|oud|ohs_standalone
  Boolean $bam_enabled                                    = true,  #only for SOA Suite
  Boolean $b2b_enabled                                    = false, #only for SOA Suite 12.1.3 with b2b
  Boolean $ess_enabled                                    = false, #only for SOA Suite 12.1.3
  Boolean $owsm_enabled                                   = false, #only for OSB domain_template on 10.3.6
  String $domain_name                                     = undef,
  Boolean $development_mode                               = true,
  String $adminserver_name                                = 'AdminServer',
  String $adminserver_machine_name                        = 'LocalMachine',
  Optional[String] $adminserver_address                   = 'localhost',
  Integer $adminserver_port                               = 7001,
  Optional[Integer] $adminserver_ssl_port                 = undef,
  Boolean $adminserver_listen_on_all_interfaces           = false,
  Hash $java_arguments                                    = {}, # java_arguments = { "ADM" => "...", "OSB" => "...", "SOA" => "...", "BAM" => "..."}
  Integer $nodemanager_port                               = 5556,
  Boolean $nodemanager_secure_listener                    = true,
  String $weblogic_user                                   = 'weblogic',
  String $weblogic_password                               = undef,
  Optional[String] $nodemanager_username                  = undef, # When not specified, it'll use the weblogic_user
  Optional[String] $nodemanager_password                  = undef, # When not specified, it'll use the weblogic_password
  Optional[String] $domain_password                       = undef, # When not specified, it'll use the weblogic_password
  Boolean $jsse_enabled                                   = false,
  Boolean $webtier_enabled                                = false,
  String $os_user                                         = $::orawls::weblogic::os_user,
  String $os_group                                        = $::orawls::weblogic::os_group,
  String $download_dir                                    = $::orawls::weblogic::download_dir,
  Optional[String] $log_dir                               = undef, # /data/logs
  Boolean $log_output                                     = $::orawls::weblogic::log_output,
  Optional[String] $repository_database_url               = undef, #jdbc:oracle:thin:@192.168.50.5:1521:XE
  Optional[String] $rcu_database_url                      = undef, #localhost:1521:XE"
  Optional[String] $repository_prefix                     = 'DEV',
  Optional[String] $repository_password                   = undef,
  Optional[String] $repository_sys_user                   = 'sys',
  Optional[String] $repository_sys_password               = undef,
  Boolean $custom_trust                                   = false,
  Optional[String] $trust_keystore_file                   = undef,
  Optional[String] $trust_keystore_passphrase             = undef,
  Boolean $custom_identity                                = false,
  Optional[String] $custom_identity_keystore_filename     = undef,
  Optional[String] $custom_identity_keystore_passphrase   = undef,
  Optional[String] $custom_identity_alias                 = undef,
  Optional[String] $custom_identity_privatekey_passphrase = undef,
  Boolean $create_rcu                                     = true,
  Optional[String] $ohs_standalone_listen_address         = undef,
  Optional[Integer] $ohs_standalone_listen_port           = undef,
  Optional[Integer] $ohs_standalone_ssl_listen_port       = undef,
  String $wls_domains_file                                = '/etc/wls_domains.yaml',
  String $puppet_os_user                                  = 'root',
  Boolean $create_default_coherence_cluster               = true,
)
{
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
  $found = orawls::domain_exists($domain_dir)

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

      $templateOHS          = 'dummy'
      $templateCoherence    = 'dummy'

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

      $templateOHS          = 'dummy'
      $templateCoherence    = 'dummy'

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

    } elsif $version >= 1221 {
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
      $templateFile = 'orawls/domains/domain.py.epp'
    }

    if $domain_template == 'ohs_standalone' {
      if ( $version == 1212 or $version == 1213 or $version >= 1221) {
        $extensionsTemplateFile = undef
        $wlstPath       = "${middleware_home_dir}/ohs/common/bin"
        $templateFile = 'orawls/ohs/domain.py.epp'
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

      if ( $version >= 1221 ) {
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

      if ( $version >= 1221 ) {
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

      if ( $version >= 1221) {
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

      if ( $version >= 1221) {
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

      if ( $version >= 1221) {
        $wlstPath      = "${middleware_home_dir}/oracle_common/common/bin"
      }
      else {
        $wlstPath      = "${middleware_home_dir}/Oracle_WC1/common/bin"
      }
    } elsif $domain_template == 'wc_wcc_bpm' {
      $extensionsTemplateFile = 'orawls/domains/extensions/wc_wcc_template.py.erb'

      if ( $version >= 1221 ) {
        $wlstPath      = "${middleware_home_dir}/oracle_common/common/bin"
      }
      else {
        $wlstPath      = "${middleware_home_dir}/Oracle_WCC1/common/bin"
      }
    } else {
      $extensionsTemplateFile = undef

      $wlstPath       = "${weblogic_home_dir}/common/bin"
    }

    $exec_path         = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

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
          user    => $puppet_os_user,
          path    => $exec_path,
        }
      }

      if !defined(File[$log_dir]) {
        file { $log_dir:
          ensure  => directory,
          recurse => true,
          replace => false,
          require => Exec["create ${log_dir} directory"],
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
        }
      }
    }

    # the utils.py used by the wlst
    if !defined(File["${download_dir}/utils.py"]) {
      file { "${download_dir}/utils.py":
        ensure  => present,
        path    => "${download_dir}/utils.py",
        source  => 'puppet:///modules/orawls/wlst/utils.py',
        replace => true,
        backup  => false,
        mode    => lookup('orawls::permissions'),
        owner   => $os_user,
        group   => $os_group,
      }
    }

    if($extensionsTemplateFile) {
      file { "domain_extension.py ${domain_name} ${title}":
        ensure  => present,
        path    => "${download_dir}/domain_extension_${domain_name}.py",
        content => template($extensionsTemplateFile),
        replace => true,
        backup  => false,
        mode    => lookup('orawls::permissions'),
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
      content => epp($templateFile, {
                    'domain_name'                           => $domain_name,
                    'domain_dir'                            => $domain_dir,
                    'version'                               => $version,
                    'templateOHS'                           => $templateOHS,
                    'template'                              => $template,
                    'templateCoherence'                     => $templateCoherence,
                    'nodemanager_username'                  => $nodemanager_username,
                    'nodemanager_password'                  => $nodemanager_password,
                    'adminserver_address'                   => $adminserver_address,
                    'adminserver_port'                      => $adminserver_port,
                    'ohs_standalone_listen_address'         => $ohs_standalone_listen_address,
                    'ohs_standalone_listen_port'            => $ohs_standalone_listen_port,
                    'ohs_standalone_ssl_listen_port'        => $ohs_standalone_ssl_listen_port,
                    'download_dir'                          => $download_dir,
                    'weblogic_home_dir'                     => $weblogic_home_dir,
                    'apps_dir'                              => $apps_dir,
                    'jsse_enabled'                          => $jsse_enabled,
                    'development_mode'                      => $development_mode,
                    'adminserver_name'                      => $adminserver_name,
                    'weblogic_user'                         => $weblogic_user,
                    'weblogic_password'                     => $weblogic_password,
                    'jdk_home_dir'                          => $jdk_home_dir,
                    'domain_password'                       => $domain_password,
                    'adminserver_listen_on_all_interfaces'  => $adminserver_listen_on_all_interfaces,
                    'nodemanager_secure_listener'           => $nodemanager_secure_listener,
                    'create_default_coherence_cluster'      => $create_default_coherence_cluster,
                    'java_arguments'                        => $java_arguments,
                    'admin_nodemanager_log_dir'             => $admin_nodemanager_log_dir,
                    'adminserver_machine_name'              => $adminserver_machine_name,
                    'adminserver_ssl_port'                  => $adminserver_ssl_port,
                    'custom_identity'                       => $custom_identity,
                    'custom_identity_keystore_filename'     => $custom_identity_keystore_filename,
                    'custom_identity_keystore_passphrase'   => $custom_identity_keystore_passphrase,
                    'trust_keystore_file'                   => $trust_keystore_file,
                    'trust_keystore_passphrase'             => $trust_keystore_passphrase,
                    'custom_identity_alias'                 => $custom_identity_alias,
                    'custom_identity_privatekey_passphrase' => $custom_identity_privatekey_passphrase }),
      replace => true,
      backup  => false,
      mode    => lookup('orawls::permissions'),
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
            mode    => lookup('orawls::permissions'),
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
        recurse => true,
        replace => false,
        mode    => lookup('orawls::permissions'),
        owner   => $os_user,
        group   => $os_group,
      }
    }

    if $apps_dir != undef {
      if !defined(File[$apps_dir]) {
        # check oracle install folder
        file { $apps_dir:
          ensure  => directory,
          recurse => true,
          replace => false,
          mode    => lookup('orawls::permissions'),
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

    if ($domain_template == 'ohs_standalone') {
      ## Create OHS standalone config directory
      file { "${domain_dir}/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d":
        ensure  => directory,
        owner   => $os_user,
        group   => $os_group,
        mode    => '0640',
        require => Exec["execwlst ${domain_name} ${title}"],
      }

      if ( $version <= 1213 ){
        $source_mod = 'puppet:///modules/orawls/mod_wl_ohs.conf'
      } else {
        $source_mod = 'puppet:///modules/orawls/mod_wl_ohs_12c.conf'
      }

      file { "${domain_dir}/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.conf":
        ensure  => present,
        source  => $source_mod,
        owner   => $os_user,
        group   => $os_group,
        mode    => '0640',
        require => Exec["execwlst ${domain_name} ${title}"],
      }
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

    # remove nodemanager properties so we can later add custom trust parameters in nodemanager.p
    if ( $custom_trust == true and ($version == 1212 or $version == 1213 or $version >= 1211 )) {
      exec { "rm ${domain_name} nodemanager.properties":
        command => "rm -rf ${$domain_dir}/nodemanager/nodemanager.properties",
        cwd     => $download_dir,
        timeout => 0,
        path    => $exec_path,
        user    => $os_user,
        group   => $os_group,
        require => Exec["execwlst ${domain_name} ${title}"],
      }
      if $extensionsTemplateFile {
        Exec["execwlst ${domain_name} extension ${title}"] -> Exec["rm ${domain_name} nodemanager.properties"]
      }
    }

    yaml_setting { "domain ${title}":
      target  =>  $wls_domains_file,
      key     =>  "domains/${domain_name}",
      value   =>  $domain_dir,
      require =>  Exec["execwlst ${domain_name} ${title}"],
    }

    if ($domain_template == 'oim') {

      file { "${download_dir}/${title}psa_opss_upgrade.rsp":
        ensure  => present,
        content => template('orawls/oim/psa_opss_upgrade.rsp.erb'),
        mode    => lookup('orawls::permissions'),
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

    if $facts['kernel'] == 'SunOS' {

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

        if ( $owsm_enabled == true ) {
          exec { "setDERBY_FLAGOnFalse ${domain_name} ${title}":
            command => "sed -e's/DERBY_FLAG=\"true\"/DERBY_FLAG=\"false\"/g' ${domain_dir}/bin/setDomainEnv.sh > /tmp/domain3.tmp && mv /tmp/domain3.tmp ${domain_dir}/bin/setDomainEnv.sh",
            onlyif  => "/bin/grep DERBY_FLAG=\"true\" ${domain_dir}/bin/setDomainEnv.sh | /usr/bin/wc -l",
            require => Exec["setOSBDebugFlagOnFalse ${domain_name} ${title}"],
            path    => $exec_path,
            user    => $os_user,
            group   => $os_group,
          }
        } else {
          exec { "setDERBY_FLAGOnTrue ${domain_name} ${title}":
            command => "sed -e's/DERBY_FLAG=\"false\"/DERBY_FLAG=\"true\"/g' ${domain_dir}/bin/setDomainEnv.sh > /tmp/domain3.tmp && mv /tmp/domain3.tmp ${domain_dir}/bin/setDomainEnv.sh",
            onlyif  => "/bin/grep DERBY_FLAG=\"false\" ${domain_dir}/bin/setDomainEnv.sh | /usr/bin/wc -l",
            require => Exec["setOSBDebugFlagOnFalse ${domain_name} ${title}"],
            path    => $exec_path,
            user    => $os_user,
            group   => $os_group,
          }
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

        if ( $owsm_enabled == true ) {
          exec { "setDERBY_FLAGOnFalse ${domain_name} ${title}":
            command => "sed -i -e's/DERBY_FLAG=\"true\"/DERBY_FLAG=\"false\"/g' ${domain_dir}/bin/setDomainEnv.sh",
            onlyif  => "/bin/grep DERBY_FLAG=\"true\" ${domain_dir}/bin/setDomainEnv.sh | /usr/bin/wc -l",
            require => Exec["setOSBDebugFlagOnFalse ${domain_name} ${title}"],
            path    => $exec_path,
            user    => $os_user,
            group   => $os_group,
          }
        } else {
          exec { "setDERBY_FLAGOnTrue ${domain_name} ${title}":
            command => "sed -i -e's/DERBY_FLAG=\"false\"/DERBY_FLAG=\"true\"/g' ${domain_dir}/bin/setDomainEnv.sh",
            onlyif  => "/bin/grep DERBY_FLAG=\"false\" ${domain_dir}/bin/setDomainEnv.sh | /usr/bin/wc -l",
            require => Exec["setOSBDebugFlagOnFalse ${domain_name} ${title}"],
            path    => $exec_path,
            user    => $os_user,
            group   => $os_group,
          }
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
