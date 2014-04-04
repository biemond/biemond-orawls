# == Define: orawls::nodemanager
#
# install and configures the nodemanager
#
define orawls::nodemanager (
  $version                   = hiera('wls_version'               , 1111),  # 1036|1111|1211|1212
  $middleware_home_dir       = hiera('wls_middleware_home_dir'   , undef), # /opt/oracle/middleware11gR1
  $weblogic_home_dir         = hiera('wls_weblogic_home_dir'     , undef),
  $nodemanager_port          = hiera('domain_nodemanager_port'   , 5556),
  $nodemanager_address       = undef,
  $nodemanager_java_mem_args = hiera('nodemanager_java_mem_args' , '-Xms32m -Xmx200m -XX:PermSize=128m -XX:MaxPermSize=256m'),
  $jsse_enabled              = hiera('wls_jsse_enabled'          , false),
  $wls_domains_dir           = hiera('wls_domains_dir'           , undef),
  $domain_name               = hiera('domain_name'               , undef),
  $jdk_home_dir              = hiera('wls_jdk_home_dir'          , undef), # /usr/java/jdk1.7.0_45
  $os_user                   = hiera('wls_os_user'               , undef), # oracle
  $os_group                  = hiera('wls_os_group'              , undef), # dba
  $download_dir              = hiera('wls_download_dir'          , undef), # /data/install
  $log_dir                   = hiera('wls_log_dir'               , undef), # /data/logs
  $log_output                = false, # true|false
)
{

  if ( $wls_domains_dir == undef ) {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir 
  }

  if ( $version == 1111 or $version == 1036 or $version == 1211 ) {
    $nodeMgrHome = "${weblogic_home_dir}/common/nodemanager"
    $startHome   = "${weblogic_home_dir}/server/bin"
  } elsif $version == 1212 {
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
      $nativeLib      = "linux/x86_64"
      $suCommand      = "su -l ${os_user}"
      $java_statement = "java"
    }
    'SunOS': {
      $checkCommand   = "/usr/ucb/ps wwxa | grep -v grep | /bin/grep 'weblogic.NodeManager'"
      $nativeLib      = "solaris/x64"
      $suCommand      = "su - ${os_user}"
      $java_statement = "java -d64"
    }
    default: {
      fail("Unrecognized operating system ${::kernel}, please use it on a Linux host")
    }
  }

  Exec {
    logoutput => $log_output,
  }

  # nodemanager is part of the domain creation
  if (  $version == 1111 or $version == 1036 or $version == 1211 ){
    file { "nodemanager.properties ux ${title}":
      ensure  => present,
      path    => "${nodeMgrHome}/nodemanager.properties",
      replace => true,
      content => template("orawls/nodemgr/nodemanager.properties.erb"),
      owner   => $os_user,
      group   => $os_group,
      before  => Exec["startNodemanager ${title}"],
    }
  }

  if $jsse_enabled == true {
    $env = "JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true"
  } else {
    $env = "JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=false -Dweblogic.security.SSL.enableJSSE=false"
  }

  exec { "startNodemanager ${title}":
    command     => "nohup ${startHome}/startNodeManager.sh &",
    environment => $env,
    unless      => $checkCommand,
    path        => $exec_path,
    user        => $os_user,
    group       => $os_group,
    cwd         => $nodeMgrHome,
  }

  exec { "sleep 20 sec for wlst exec ${title}":
      command     => "/bin/sleep 20",
      subscribe   => Exec["startNodemanager ${title}"],
      refreshonly => true,
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
  }
}
