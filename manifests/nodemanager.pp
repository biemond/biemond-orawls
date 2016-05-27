# == Define: orawls::nodemanager
#
# install and configures the nodemanager
#
define orawls::nodemanager (
  $domain_name                           = undef,
  $version                               = $::orawls::weblogic::version,  # 1036|1111|1211|1212|1213
  $middleware_home_dir                   = $::orawls::weblogic::middleware_home_dir, # /opt/oracle/middleware11gR1
  $weblogic_home_dir                     = $::orawls::weblogic::weblogic_home_dir,
  $nodemanager_port                      = 5556,
  $nodemanager_address                   = undef,
  $nodemanager_secure_listener           = true,
  $jsse_enabled                          = false,
  $custom_trust                          = false,
  $trust_keystore_file                   = undef,
  $trust_keystore_passphrase             = undef,
  $custom_identity                       = false,
  $custom_identity_keystore_filename     = undef,
  $custom_identity_keystore_passphrase   = undef,
  $custom_identity_alias                 = undef,
  $custom_identity_privatekey_passphrase = undef,
  $wls_domains_dir                       = $::orawls::weblogic::wls_domains_dir,
  $jdk_home_dir                          = $::orawls::weblogic::jdk_home_dir, # /usr/java/jdk1.7.0_45
  $os_user                               = $::orawls::weblogic::os_user, # oracle
  $os_group                              = $::orawls::weblogic::os_group, # dba
  $download_dir                          = $::orawls::weblogic::download_dir, # /data/install
  $log_dir                               = undef, # /data/logs
  $log_file                              = 'nodemanager.log',
  $log_output                            = $::orawls::weblogic::log_output, # true|false
  $sleep                                 = 20, # default sleep time
  $properties                            = {},
  $ohs_standalone                        = false,
)
{
  # Must include domain_name
  unless $domain_name {
    fail('A nodemanager must be associated with a domain.')
  }

  if ( $wls_domains_dir == undef or $wls_domains_dir == '' ) {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  if ( $version == 1111 or $version == 1036 or $version == 1211 ) {
    $nodeMgrHome = "${weblogic_home_dir}/common/nodemanager"
    $startHome   = "${weblogic_home_dir}/server/bin"
  } elsif $version == 1212 or $version == 1213 or $version == 1221 {
    $nodeMgrHome = "${domains_dir}/${domain_name}/nodemanager"
    $startHome   = "${domains_dir}/${domain_name}/bin"
  } else {
    $nodeMgrHome = "${weblogic_home_dir}/common/nodemanager"
    $startHome   = "${weblogic_home_dir}/server/bin"
  }

  $exec_path    = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

  if $log_dir == undef {
    $nodeMgrLogDir = "${nodeMgrHome}/${log_file}"
  } else {
      # create all folders
      if !defined(Exec["create ${log_dir} directory"]) {
        exec { "create ${log_dir} directory":
          command => "mkdir -p ${log_dir}",
          unless  => "test -d ${log_dir}",
          user    => 'root',
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

  case $::kernel {
    'Linux': {
      if ( $version == 1212 or $version == 1213 or $version == 1221 ){
        $checkCommand = "/bin/ps -ef | grep -v grep | /bin/grep 'weblogic.NodeManager' | /bin/grep ${domain_name}"
      } else {
        $checkCommand = '/bin/ps -ef | grep -v grep | /bin/grep \'weblogic.NodeManager\''
      }
      $nativeLib         = 'linux/x86_64'
      $suCommand         = "su -l ${os_user}"
      $java_statement    = 'java'
      $netstat_statement = "/bin/netstat -lnt | /bin/grep ':${nodemanager_port}'"
    }
    'SunOS': {
      case $::kernelrelease {
        '5.11': {
          if ( $version == 1212 or $version == 1213 or $version == 1221 ){
            $checkCommand = "/bin/ps wwxa | /bin/grep -v grep | /bin/grep 'weblogic.NodeManager' | /bin/grep ${domain_name}"
          } else {
            $checkCommand = '/bin/ps wwxa | /bin/grep -v grep | /bin/grep \'weblogic.NodeManager\''
          }
        }
        default: {
          if ( $version == 1212 or $version == 1213 or $version == 1221 ){
            $checkCommand = "/usr/ucb/ps wwxa | /bin/grep -v grep | /bin/grep 'weblogic.NodeManager' | /bin/grep ${domain_name}"
          } else {
            $checkCommand = '/usr/ucb/ps wwxa | /bin/grep -v grep | /bin/grep \'weblogic.NodeManager\''
          }
        }
      }
      $nativeLib         = 'solaris/x64'
      $suCommand         = "su - ${os_user}"
      $java_statement    = 'java -d64'
      $netstat_statement = "/bin/netstat -an -P tcp | /bin/grep LISTEN | /bin/grep '.${nodemanager_port}'"
    }
    default: {
      fail("Unrecognized operating system ${::kernel}, please use it on a Linux or Solaris host")
    }
  }

  Exec {
    logoutput => $log_output,
  }

  if $custom_identity == true {
    $replaceNodemanagerProperties = false
  } else {
    $replaceNodemanagerProperties = true
  }

  $property_defaults = {
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
    file { "nodemanager.properties ux ${title}":
      ensure  => present,
      path    => "${nodeMgrHome}/nodemanager.properties",
      replace => $replaceNodemanagerProperties,
      content => template('orawls/nodemgr/nodemanager.properties.erb'),
      owner   => $os_user,
      group   => $os_group,
      mode    => '0775',
      before  => Exec["startNodemanager ${title}"],
    }
  } else {
    file { "nodemanager.properties ux ${version} ${title}":
      ensure  => present,
      path    => "${nodeMgrHome}/nodemanager.properties",
      replace => true,
      content => template("orawls/nodemgr/nodemanager.properties_${version}.erb"),
      owner   => $os_user,
      group   => $os_group,
      mode    => '0775',
      before  => Exec["startNodemanager ${title}"],
    }
  }

  if ( $custom_trust == true ) {
    $trust_env = "-Dweblogic.security.TrustKeyStore=CustomTrust -Dweblogic.security.CustomTrustKeyStoreFileName=${trust_keystore_file} -Dweblogic.security.CustomTrustKeystorePassPhrase=${trust_keystore_passphrase}"
  } else {
    $trust_env = ''
  }

  if $jsse_enabled == true {
    $env = "JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true ${trust_env}"
  } else {
    $env = "JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=false -Dweblogic.security.SSL.enableJSSE=false ${trust_env}"
  }

  exec { "startNodemanager ${title}":
    command     => "nohup ${startHome}/startNodeManager.sh &",
    environment => [ $env, "JAVA_HOME=${jdk_home_dir}", 'JAVA_VENDOR=Oracle' ],
    unless      => $checkCommand,
    path        => $exec_path,
    user        => $os_user,
    group       => $os_group,
    cwd         => $nodeMgrHome,
  }

  # using fiddyspence/sleep module
  sleep { "wake up ${title}":
    bedtime       => $sleep,
    wakeupfor     => $netstat_statement,
    dozetime      => 2,
    failontimeout => true,
    subscribe     => Exec["startNodemanager ${title}"],
    refreshonly   => true,
  }
}
