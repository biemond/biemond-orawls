#
# copydomain define
#
# copydomain to an other nodes
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
#
define orawls::copydomain (
  Integer $version                            = $::orawls::weblogic::version,
  String $weblogic_home_dir                   = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir                 = $::orawls::weblogic::middleware_home_dir,
  String $jdk_home_dir                        = $::orawls::weblogic::jdk_home_dir,
  String $wls_domains_dir                     = $::orawls::weblogic::wls_domains_dir,
  String $wls_apps_dir                        = $::orawls::weblogic::wls_apps_dir,
  String $domain_name                         = undef,
  String $os_user                             = $::orawls::weblogic::os_user,
  String $os_group                            = $::orawls::weblogic::os_group,
  String $download_dir                        = $::orawls::weblogic::download_dir,
  Boolean $log_output                         = $::orawls::weblogic::log_output,
  Optional[String] $domain_pack_dir           = undef,
  String $adminserver_address                 = 'localhost',
  Integer $adminserver_port                   = 7001,
  Boolean $use_ssh                            = true,
  Boolean $use_t3s                            = false,
  String $weblogic_user                       = 'weblogic',
  String $weblogic_password                   = undef,
  Optional[String] $log_dir                   = undef, # /data/logs
  Enum['dev','prod'] $server_start_mode       = 'dev',
  String $wls_domains_file                    = '/etc/wls_domains.yaml',
  String $puppet_os_user                      = 'root',
  Boolean $jsse_enabled                       = false,
  Boolean $custom_trust                       = false,
  Optional[String] $trust_keystore_file       = undef,
  Optional[String] $trust_keystore_passphrase = undef,
  String $extra_arguments                     = '', # '-Dweblogic.security.SSL.minimumProtocolVersion=TLSv1'
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

  if ( $version == 1036 or $version == 1111 or $version == 1211 ) {
    $nodeMgrHome = "${weblogic_home_dir}/common/nodemanager"

  } elsif ( $version == 1212 or $version == 1213 or $version >= 1221) {
    $nodeMgrHome = "${domains_dir}/${domain_name}/nodemanager"

  } else {
    $nodeMgrHome = "${weblogic_home_dir}/common/nodemanager"
  }

  if ( $domain_pack_dir == undef ) {
    $remote_or_share_domain_domain_dir = $download_dir
  } else {
    $remote_or_share_domain_domain_dir = $domain_pack_dir
  }

  # check if the domain already exists
  $found = domain_exists("${domains_dir}/${domain_name}", $version, $domains_dir)

  if $found == undef {
    $continue = true
  } else {
    if ($found) {
      $continue = false
    } else {
      notify { "orawls::wlsdomain ${title} ${domains_dir}/${domain_name} ${version} does not exists": }
      $continue = true
    }
  }

  if ($continue) {
    $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

    if $log_dir != undef {

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
          recurse => false,
          replace => false,
          require => Exec["create ${log_dir} directory"],
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
        }
      }
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
        recurse => false,
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
          recurse => false,
          replace => false,
          mode    => lookup('orawls::permissions'),
          owner   => $os_user,
          group   => $os_group,
        }
      }
    }

    # copy domain from the adminserver to the this node ( with scp and without passwords )
    if ( $use_ssh == true ) {
      exec { "copy domain jar ${domain_name}":
        command   => "scp -oStrictHostKeyChecking=no -oCheckHostIP=no ${os_user}@${adminserver_address}:${remote_or_share_domain_domain_dir}/domain_${domain_name}.jar ${download_dir}/domain_${domain_name}.jar",
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        logoutput => $log_output,
      }
    } else {
      exec { "copy domain jar ${domain_name}":
        command   => "cp ${remote_or_share_domain_domain_dir}/domain_${domain_name}.jar ${download_dir}/domain_${domain_name}.jar",
        path      => $exec_path,
        user      => $os_user,
        group     => $os_group,
        logoutput => $log_output,
      }
    }

    $app_dir_arg = $apps_dir ? {
      undef      => '',
      default    => "-app_dir=${apps_dir}/${domain_name}"
    }

    $unPackCommand = "-domain=${domains_dir}/${domain_name} -template=${download_dir}/domain_${domain_name}.jar ${$app_dir_arg} -server_start_mode=${server_start_mode} -log=${download_dir}/domain_${domain_name}.log -log_priority=INFO"

    if ( $version >= 1221 ) {
      $bin_dir = "${middleware_home_dir}/oracle_common/common/bin/unpack.sh"
      $wlst_dir = "${middleware_home_dir}/oracle_common/common/bin/wlst.sh"
    } else {
      $bin_dir = "${weblogic_home_dir}/common/bin/unpack.sh"
      $wlst_dir = "${weblogic_home_dir}/common/bin/wlst.sh"
    }

    exec { "unpack ${domain_name}":
      command     => "${bin_dir} ${unPackCommand} -user_name=${weblogic_user} -password=${weblogic_password}",
      environment => ["JAVA_HOME=${jdk_home_dir}"],
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      logoutput   => $log_output,
      timeout     => 0,
      require     => [File[$domains_dir],
                    Exec["copy domain jar ${domain_name}"]],
    }

    yaml_setting { "domain ${title}":
      target =>  $wls_domains_file,
      key    =>  "domains/${domain_name}",
      value  =>  "${domains_dir}/${domain_name}",
    }

    # the enroll domain.py used by the wlst
    file { "enroll.py ${domain_name} ${title}":
      ensure  => present,
      path    => "${download_dir}/enroll_domain_${domain_name}.py",
      content => epp('orawls/wlst/enrollDomain.py.epp',{
                      'adminserver_address' => $adminserver_address,
                      'adminserver_port'    => $adminserver_port,
                      'domains_dir'         => $domains_dir,
                      'domain_name'         => $domain_name,
                      'nodeMgrHome'         => $nodeMgrHome,
                      'use_t3s'             => $use_t3s }),
      replace => true,
      mode    => lookup('orawls::permissions'),
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
    }

    if $custom_trust == true {
      $config = "-Dweblogic.ssl.JSSEEnabled=${jsse_enabled} -Dweblogic.security.SSL.enableJSSE=${jsse_enabled} -Dweblogic.security.TrustKeyStore=CustomTrust -Dweblogic.security.CustomTrustKeyStoreFileName=${trust_keystore_file} -Dweblogic.security.CustomTrustKeystorePassPhrase=${trust_keystore_passphrase} ${extra_arguments}"
      if ($version == 1212 or $version == 1213 or $version >= 1221) {
        # remove nodemanager.properties, else it won't be updated by nodemanager
        exec { "rm ${domains_dir}/${domain_name}/nodemanager/nodemanager.properties":
          path      => $exec_path,
          user      => $os_user,
          group     => $os_group,
          logoutput => $log_output,
          require   => Exec["unpack ${domain_name}"],
        }
      }
    }
    else {
      $config = "-Dweblogic.ssl.JSSEEnabled=${jsse_enabled} -Dweblogic.security.SSL.enableJSSE=${jsse_enabled} ${extra_arguments}"
    }

    exec { "execwlst ${domain_name} ${title}":
      command     => "${wlst_dir} ${download_dir}/enroll_domain_${domain_name}.py ${weblogic_password}",
      environment => ["JAVA_HOME=${jdk_home_dir}", "CONFIG_JVM_ARGS=${config}"],
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
      logoutput   => $log_output,
      require     => [File["${download_dir}/enroll_domain_${domain_name}.py"],
                      Exec["unpack ${domain_name}"]],
    }

    exec { "domain.py ${domain_name} ${title}":
      command   => "rm ${download_dir}/enroll_domain_${domain_name}.py",
      path      => $exec_path,
      user      => $os_user,
      group     => $os_group,
      logoutput => $log_output,
      require   => Exec["execwlst ${domain_name} ${title}"],
    }

  }
}