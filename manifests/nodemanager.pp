# == Define: orawls::nodemanager
#
# install and configures the nodemanager
#
define orawls::nodemanager (
  $version                               = hiera('wls_version'                   , 1111),  # 1036|1111|1211|1212
  $middleware_home_dir                   = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $weblogic_home_dir                     = hiera('wls_weblogic_home_dir'),
  $nodemanager_port                      = hiera('domain_nodemanager_port'       , 5556),
  $nodemanager_address                   = undef,
  $jsse_enabled                          = hiera('wls_jsse_enabled'              , false),
  $custom_trust                          = hiera('wls_custom_trust'              , false),
  $trust_keystore_file                   = hiera('wls_trust_keystore_file'       , undef),
  $trust_keystore_passphrase             = hiera('wls_trust_keystore_passphrase' , undef),
  $custom_identity                       = false,
  $custom_identity_keystore_filename     = undef,
  $custom_identity_keystore_passphrase   = undef,
  $custom_identity_alias                 = undef,
  $custom_identity_privatekey_passphrase = undef,
  $wls_domains_dir                       = hiera('wls_domains_dir'               , undef),
  $domain_name                           = hiera('domain_name'                   , undef),
  $jdk_home_dir                          = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $os_user                               = hiera('wls_os_user'), # oracle
  $os_group                              = hiera('wls_os_group'), # dba
  $download_dir                          = hiera('wls_download_dir'), # /data/install
  $log_dir                               = hiera('wls_log_dir'                   , undef), # /data/logs
  $log_output                            = false, # true|false
  $sleep                                 = hiera('wls_nodemanager_sleep'         , 20), # default sleep time
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
  } elsif $version == 1212 or $version == 1213 {
    $nodeMgrHome = "${domains_dir}/${domain_name}/nodemanager"
    $startHome   = "${domains_dir}/${domain_name}/bin"
  } else {
    $nodeMgrHome = "${weblogic_home_dir}/common/nodemanager"
    $startHome   = "${weblogic_home_dir}/server/bin"
  }

  $exec_path    = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

  if $log_dir == undef {
    $nodeMgrLogDir = "${nodeMgrHome}/nodemanager.log"
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
        }
      }
      $nodeMgrLogDir = "${log_dir}/nodemanager.log"
  }

  case $::kernel {
    'Linux': {
      $checkCommand   = "/bin/ps -ef | grep -v grep | /bin/grep 'weblogic.NodeManager'"
      $nativeLib      = 'linux/x86_64'
      $suCommand      = "su -l ${os_user}"
      $java_statement = 'java'
    }
    'SunOS': {
      $checkCommand   = "/usr/ucb/ps wwxa | grep -v grep | /bin/grep 'weblogic.NodeManager'"
      $nativeLib      = 'solaris/x64'
      $suCommand      = "su - ${os_user}"
      $java_statement = 'java -d64'
    }
    default: {
      fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
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

  # nodemanager is part of the domain creation
  if ( $version == 1111 or $version == 1036 or $version == 1211 ){
    file { "nodemanager.properties ux ${title}":
      ensure  => present,
      path    => "${nodeMgrHome}/nodemanager.properties",
      replace => $replaceNodemanagerProperties,
      content => template('orawls/nodemgr/nodemanager.properties.erb'),
      owner   => $os_user,
      group   => $os_group,
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

  exec { "sleep ${sleep} sec for wlst exec ${title}":
      command     => "/bin/sleep ${sleep}",
      subscribe   => Exec["startNodemanager ${title}"],
      refreshonly => true,
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
  }
}
