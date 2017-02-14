# == Define: orawls::nodemanager
#
# install and configures the nodemanager
#
define orawls::nodemanager (
  Integer $version                                        = $::orawls::weblogic::version,
  String $weblogic_home_dir                               = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir,
  Integer $nodemanager_port                               = 5556,
  String $nodemanager_address                             = undef,
  Boolean $nodemanager_secure_listener                    = true,
  Boolean $jsse_enabled                                   = false,
  Boolean $custom_trust                                   = false,
  Optional[String] $trust_keystore_file                   = undef,
  Optional[String] $trust_keystore_passphrase             = undef,
  Boolean $custom_identity                                = false,
  Optional[String] $custom_identity_keystore_filename     = undef,
  Optional[String] $custom_identity_keystore_passphrase   = undef,
  Optional[String] $custom_identity_alias                 = undef,
  Optional[String] $custom_identity_privatekey_passphrase = undef,
  String $extra_arguments                                 = '', # '-Dweblogic.security.SSL.minimumProtocolVersion=TLSv1'
  Optional[String] $wls_domains_dir                       = $::orawls::weblogic::wls_domains_dir,
  String $domain_name                                     = undef,
  String $jdk_home_dir                                    = $::orawls::weblogic::jdk_home_dir,
  String $os_user                                         = $::orawls::weblogic::os_user,
  String $os_group                                        = $::orawls::weblogic::os_group,
  String $download_dir                                    = $::orawls::weblogic::download_dir,
  Optional[String] $log_dir                               = undef, # /data/logs
  String $log_file                                        = 'nodemanager.log',
  Boolean $log_output                                     = $::orawls::weblogic::log_output,
  Integer $sleep                                          = 20, # default sleep time
  Hash $properties                                        = {},
  Boolean $ohs_standalone                                 = false,
  String $puppet_os_user                                  = 'root',
)
{

  if ( $wls_domains_dir == undef or $wls_domains_dir == '' ) {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  if ( $version == 1111 or $version == 1036 or $version == 1211 ) {
    $nodeMgrHome = "${weblogic_home_dir}/common/nodemanager"
    $startHome   = "${weblogic_home_dir}/server/bin"
  } elsif $version == 1212 or $version == 1213 or $version >= 1221 {
    $nodeMgrHome = "${domains_dir}/${domain_name}/nodemanager"
    $startHome   = "${domains_dir}/${domain_name}/bin"
  } else {
    $nodeMgrHome = "${weblogic_home_dir}/common/nodemanager"
    $startHome   = "${weblogic_home_dir}/server/bin"
  }

  $exec_path         = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

  if $log_dir == undef {
    $nodeMgrLogDir = "${nodeMgrHome}/${log_file}"
  } else {
      # create all folders
      if !defined(Exec["create ${log_dir} directory"]) {
        exec { "create ${log_dir} directory":
          command => "mkdir -p ${log_dir}",
          unless  => "test -d ${log_dir}",
          user    => $puppet_os_user,
          path    => $exec_path,
          group   => $os_group,
          cwd     => $nodeMgrHome,
        }
      }
      if !defined(File[$log_dir]) {
        file { $log_dir:
          ensure  => directory,
          recurse => false,
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          require => Exec["create ${log_dir} directory"],
          before  => Exec["startNodemanager ${title}"],
        }
      }
      $nodeMgrLogDir = "${log_dir}/${log_file}"
  }

  $java_statement    = lookup('orawls::java')
  $nativeLib         = lookup('orawls::native_lib')

  case $facts['kernel'] {
    'Linux': {
      if ( $version == 1212 or $version == 1213 or $version >= 1221 ){
        $checkCommand = "/bin/ps -eo pid,cmd | grep -v grep | /bin/grep 'weblogic.NodeManager' | /bin/grep ${domain_name}"
      } else {
        $checkCommand = '/bin/ps -eo pid,cmd | grep -v grep | /bin/grep \'weblogic.NodeManager\''
      }
      $suCommand         = "su -l ${os_user}"
      $netstat_statement = "/bin/netstat -lnt | /bin/grep ':${nodemanager_port}'"
    }
    'SunOS': {
      case $facts['kernelrelease'] {
        '5.11': {
          if ( $version == 1212 or $version == 1213 or $version >= 1221 ){
            $checkCommand = "/bin/ps wwxa | /bin/grep -v grep | /bin/grep 'weblogic.NodeManager' | /bin/grep ${domain_name}"
          } else {
            $checkCommand = '/bin/ps wwxa | /bin/grep -v grep | /bin/grep \'weblogic.NodeManager\''
          }
        }
        default: {
          if ( $version == 1212 or $version == 1213 or $version >= 1221 ){
            $checkCommand = "/usr/ucb/ps wwxa | /bin/grep -v grep | /bin/grep 'weblogic.NodeManager' | /bin/grep ${domain_name}"
          } else {
            $checkCommand = '/usr/ucb/ps wwxa | /bin/grep -v grep | /bin/grep \'weblogic.NodeManager\''
          }
        }
      }
      $suCommand         = "su - ${os_user}"
      $netstat_statement = "/bin/netstat -an -P tcp | /bin/grep LISTEN | /bin/grep '.${nodemanager_port}'"
    }
    default: {
      fail("Unrecognized operating system ${::kernel}, please use it on a Linux or Solaris host")
    }
  }

  Exec {
    logoutput => $log_output,
  }

  # do it once but don't replace it because of encrypted trust passwords
  if $custom_identity == true {
    $replaceNodemanagerProperties = false
  } else {
    $replaceNodemanagerProperties = true
  }

  if ( $version == 1111 or $version == 1036 or $version == 1211 ){
    $nodemanager_property_version = '10.3'
  } elsif $version == 1212 {
    $nodemanager_property_version = '12.1.2'
  } elsif $version == 1213 {
    $nodemanager_property_version = '12.1.3'
  } elsif $version == 1221 {
    $nodemanager_property_version = '12.2.1'
  } elsif $version == 12211 {
    $nodemanager_property_version = '12.2.1.1.0'
  } elsif $version == 12212 {
    $nodemanager_property_version = '12.2.1.2.0'
  }

  $property_defaults = {
    'properties_version'                 => $nodemanager_property_version,
    'log_limit'                          => 0,
    'domains_dir_remote_sharing_enabled' => false,
    'authentication_enabled'             => true,
    'log_level'                          => 'INFO',
    'domains_file_enabled'               => true,
    'start_script_name'                  => 'startWebLogic.sh',
    'native_version_enabled'             => true,
    'log_to_stderr'                      => true,
    'log_count'                          => '1',
    'domain_registration_enabled'        => false,
    'stop_script_enabled'                => true,
    'quit_enabled'                       => false,
    'log_append'                         => true,
    'state_check_interval'               => 500,
    'crash_recovery_enabled'             => true,
    'start_script_enabled'               => true,
    'log_formatter'                      => 'weblogic.nodemanager.server.LogFormatter',
    'listen_backlog'                     => 50,
  }

  $properties_merged = merge($property_defaults, $properties)

  # nodemanager is part of the domain creation
  if ( $version == 1111 or $version == 1036 or $version == 1211 ){
    $propertiesFileTitle = "nodemanager.properties ux ${title}"
    file { $propertiesFileTitle:
      ensure  => present,
      path    => "${nodeMgrHome}/nodemanager.properties",
      replace => $replaceNodemanagerProperties,
      content => epp('orawls/nodemgr/nodemanager.properties.epp', {
                      'weblogic_home_dir'                     => $weblogic_home_dir,
                      'jdk_home_dir'                          => $jdk_home_dir,
                      'nodemanager_address'                   => $nodemanager_address,
                      'nodemanager_port'                      => $nodemanager_port,
                      'nodemanager_secure_listener'           => $nodemanager_secure_listener,
                      'properties_merged'                     => $properties_merged,
                      'nodeMgrLogDir'                         => $nodeMgrLogDir,
                      'custom_identity'                       => $custom_identity,
                      'custom_identity_keystore_filename'     => $custom_identity_keystore_filename,
                      'custom_identity_keystore_passphrase'   => $custom_identity_keystore_passphrase,
                      'custom_identity_alias'                 => $custom_identity_alias,
                      'custom_identity_privatekey_passphrase' => $custom_identity_privatekey_passphrase }),
      owner   => $os_user,
      group   => $os_group,
      mode    => lookup('orawls::permissions_group_restricted'),
      before  => Exec["startNodemanager ${title}"],
    }
  } else {
    if $version >= 1221 {
      $new_version = 1221
    } else {
      $new_version = $version
    }

    # do not replace when it contains encrypted custom trust field like CustomIdentityKeyStorePassPhrase
    $propertiesFileTitle = "nodemanager.properties ux ${version} ${title}"
    file { $propertiesFileTitle:
      ensure  => present,
      path    => "${nodeMgrHome}/nodemanager.properties",
      replace => $replaceNodemanagerProperties,
      content => epp("orawls/nodemgr/nodemanager.properties_${new_version}.epp", {
                      'domains_dir'                           => $domains_dir,
                      'domain_name'                           => $domain_name,
                      'jdk_home_dir'                          => $jdk_home_dir,
                      'nodemanager_address'                   => $nodemanager_address,
                      'nodemanager_port'                      => $nodemanager_port,
                      'nodemanager_secure_listener'           => $nodemanager_secure_listener,
                      'properties_merged'                     => $properties_merged,
                      'nodeMgrLogDir'                         => $nodeMgrLogDir,
                      'custom_identity'                       => $custom_identity,
                      'custom_identity_keystore_filename'     => $custom_identity_keystore_filename,
                      'custom_identity_keystore_passphrase'   => $custom_identity_keystore_passphrase,
                      'custom_identity_alias'                 => $custom_identity_alias,
                      'custom_identity_privatekey_passphrase' => $custom_identity_privatekey_passphrase }),
      owner   => $os_user,
      group   => $os_group,
      mode    => lookup('orawls::permissions_group_restricted'),
      before  => Exec["startNodemanager ${title}"],
    }
  }

  if ( $custom_trust == true ) {
    $trust_env = "-Dweblogic.security.TrustKeyStore=CustomTrust -Dweblogic.security.CustomTrustKeyStoreFileName=${trust_keystore_file} -Dweblogic.security.CustomTrustKeystorePassPhrase=${trust_keystore_passphrase}"
  } else {
    $trust_env = ''
  }

  if $jsse_enabled == true {
    $env = "JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true ${trust_env} ${extra_arguments}"
  } else {
    $env = "JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=false -Dweblogic.security.SSL.enableJSSE=false ${trust_env} ${extra_arguments}"
  }

  $startCommand      = "nohup ${startHome}/startNodeManager.sh &"
  $restartCommand    = "kill $(${checkCommand} | awk '{print \$1}'); sleep 1; ${startCommand}"

  exec { "startNodemanager ${title}":
    command     => $startCommand,
    environment => [ $env, "JAVA_HOME=${jdk_home_dir}", 'JAVA_VENDOR=Oracle' ],
    unless      => $checkCommand,
    path        => $exec_path,
    user        => $os_user,
    group       => $os_group,
    cwd         => $nodeMgrHome,
  }

  exec {"restart NodeManager ${title}":
    command     => $restartCommand,
    environment => [ $env, "JAVA_HOME=${jdk_home_dir}", 'JAVA_VENDOR=Oracle' ],
    onlyif      => $checkCommand,
    path        => $exec_path,
    user        => $os_user,
    group       => $os_group,
    cwd         => $nodeMgrHome,
    refreshonly => true,
    subscribe   => File[$propertiesFileTitle],
  }

  # using fiddyspence/sleep module
  sleep { "wake up ${title}":
    bedtime       => $sleep,
    wakeupfor     => $netstat_statement,
    dozetime      => 2,
    failontimeout => true,
    subscribe     => [Exec["startNodemanager ${title}"], Exec["restart NodeManager ${title}"]],
    refreshonly   => true,
  }
}
