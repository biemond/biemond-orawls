# == Define: orawls::nodemanager
#
# install and configures the nodemanager
#
define orawls::nodemanager (
  $version                = hiera('wls_version'             , 1111),  # 1036|1111|1211|1212
  $weblogic_home_dir      = hiera('wls_weblogic_home_dir'   , undef),
  $nodemanager_port       = hiera('domain_nodemanager_port' , 5556),
  $nodemanager_address    = undef,
  $domain_name            = hiera('domain_name'             , undef),
  $jdk_home_dir           = hiera('wls_jdk_home_dir'        , undef), # /usr/java/jdk1.7.0_45
  $os_user                = hiera('wls_os_user'             , undef), # oracle
  $os_group               = hiera('wls_os_group'            , undef), # dba
  $download_dir           = hiera('wls_download_dir'        , undef), # /data/install
  $log_dir                = hiera('wls_log_dir'             , undef), # /data/logs
  $log_output             = false, # true|false
)

{
  if ( $version == 1111 or $version == 1036 or $version == 1211 ) {
    $nodeMgrHome = "${weblogic_home_dir}/common/nodemanager"

  } elsif $version == 1212 {

    if $::override_weblogic_domain_folder == undef {
      $nodeMgrHome = "${weblogic_home_dir}/../user_projects/domains/${domain_name}/nodemanager"
    } else {
      $nodeMgrHome = "${::override_weblogic_domain_folder}/domains/${domain_name}/nodemanager"
    }

  } else {
    $nodeMgrHome = "${weblogic_home_dir}/common/nodemanager"
  }

  if $log_dir == undef {
    $nodeMgrLogDir = "${nodeMgrHome}/nodemanager.log"
  } else {
    $nodeMgrLogDir = "${log_dir}/nodemanager.log"
  }

  $exec_path    = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"
  case $::kernel {
    Linux: {
      $checkCommand   = "/bin/ps -ef | grep -v grep | /bin/grep 'weblogic.NodeManager'"
      $nativeLib      = "linux/x86_64"
      $suCommand      = "su -l ${os_user}"
      $java_statement = "java"
    }
    SunOS: {
      $checkCommand   = "/usr/ucb/ps wwxa | grep -v grep | /bin/grep 'weblogic.NodeManager'"
      $nativeLib      = "solaris/x64"
      $suCommand      = "su - ${os_user}"
      $java_statement = "java -d64"
    }
  }

  Exec {
     logoutput => $log_output,
  }

  # nodemanager is part of the domain creation
  if $version == "1212" {

    if $::override_weblogic_domain_folder == undef {
      $domainsHome = "${weblogic_home_dir}/../user_projects/domains"
    } else {
      $domainsHome = "${::override_weblogic_domain_folder}/domains"
    }

    exec { "startNodemanager 1212 ${title}":
      command => "nohup ${domainsHome}/${domain_name}/bin/startNodeManager.sh &",
      unless  => "${checkCommand}",
      path    => $exec_path,
      user    => $os_user,
      group   => $os_group,
      cwd     => $nodeMgrHome,
    }

    exec { "sleep 20 sec for wlst exec ${title}":
      command     => "/bin/sleep 20",
      subscribe   => Exec["startNodemanager 1212 ${title}"],
      refreshonly => true,
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      cwd         => $nodeMgrHome,
    }
  } elsif (  $version == 1111 or $version == 1036 or $version == 1211 ){
    if $log_dir != undef {
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
      if !defined(File["${log_dir}"]) {
        file { "${log_dir}":
          ensure  => directory,
          recurse => false,
          replace => false,
          owner => $os_user,
          group => $os_group,
          require => Exec["create ${log_dir} directory"],
        }
      }
    }

    $javaCommand = "${java_statement} -client -Xms32m -Xmx200m -XX:PermSize=128m -XX:MaxPermSize=256m -DListenPort=${nodemanager_port} -Dbea.home=${weblogic_home_dir} -Dweblogic.nodemanager.JavaHome=${jdk_home_dir} -Djava.security.policy=${weblogic_home_dir}/server/lib/weblogic.policy -Xverify:none weblogic.NodeManager -v"

    file { "nodemanager.properties ux ${title}":
      path    => "${nodeMgrHome}/nodemanager.properties",
      ensure  => present,
      replace => true,
      content => template("orawls/nodemgr/nodemanager.properties.erb"),
      owner   => $os_user,
      group   => $os_group,
    }

    exec { "execwlst ux nodemanager ${title}":
      command     => "/usr/bin/nohup ${javaCommand} &",
      environment => [
        "CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
        "JAVA_HOME=${jdk_home_dir}",
        "LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${weblogic_home_dir}/server/native/${nativeLib}"],
      unless      => "${checkCommand}",
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      cwd         => $nodeMgrHome,
      require     => File["nodemanager.properties ux ${title}"],
    }

    exec { "sleep 5 sec for wlst exec ${title}":
      command     => "/bin/sleep 5",
      subscribe   => Exec["execwlst ux nodemanager ${title}"],
      refreshonly => true,
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      cwd         => $nodeMgrHome,
    }
  }
}
