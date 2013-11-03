# == Define: orawls::domain
#
# setup a new weblogic domain
##
define orawls::domain (
  $version                    = hiera('wls_version'             , 1111),  # 1036|1111|1211|1212
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'   , undef), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir' , undef), # /opt/oracle/middleware11gR1
  $jdk_home_dir               = hiera('wls_jdk_home_dir'        , undef), # /usr/java/jdk1.7.0_45
  $domain_template            = "standard",
  $domain_name                = undef,
  $development_mode           = true,
  $adminserver_name           = "AdminServer",
  $adminserver_address        = "localhost",
  $adminserver_port           = 7001,
  $nodemanager_port           = 5556,
  $weblogic_user              = hiera('wls_weblogic_user'       , "weblogic"),
  $weblogic_password          = undef,
  $os_user                    = hiera('wls_os_user'             , undef), # oracle
  $os_group                   = hiera('wls_os_group'            , undef), # dba
  $download_dir               = hiera('wls_download_dir'        , undef), # /data/install
  $log_dir                    = hiera('wls_log_dir'             , undef), # /data/logs
  $log_output                 = false, # true|false
)
{
  $domain_dir = "${middleware_home_dir}/user_projects/domains"
  $app_dir    = "${middleware_home_dir}/user_projects/applications"

  # check if the domain already exists
  $found = domain_exists("${domain_dir}/${domain_name}", $version)

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

    } elsif $version == 1121 {
      $template          = "${weblogic_home_dir}/common/templates/domains/wls.jar"
      $templateWS        = "${weblogic_home_dir}/common/templates/applications/wls_webservice.jar"

    } elsif $version == 1212 {
      $template          = "${weblogic_home_dir}/common/templates/wls/wls.jar"
      $templateWS        = "${weblogic_home_dir}/common/templates/wls/wls_webservice.jar"
      $templateJaxWS     = "${weblogic_home_dir}/common/templates/wls/wls_webservice_jaxws.jar"
      $templateSoapJms   = "${weblogic_home_dir}/common/templates/wls/wls_webservice_soapjms.jar"
      $templateCoherence = "${weblogic_home_dir}/common/templates/wls/wls_coherence.jar"

    } else {
      $template          = "${weblogic_home_dir}/common/templates/domains/wls.jar"
      $templateWS        = "${weblogic_home_dir}/common/templates/applications/wls_webservice.jar"

    }

    if $domain_template == 'standard' {
      $templateFile   = "orawls/domains/domain.py.erb"
      $wlstPath       = "${weblogic_home_dir}/common/bin"
    } else {
      $templateFile   = "orawls/domains/domain.py.erb"
      $wlstPath       = "${weblogic_home_dir}/common/bin"
    }

    $exec_path        = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"
    $JAVA_HOME        = $jdk_home_dir
    $nodeMgrMachine   = "UnixMachine"

    Exec {
      logoutput => $log_output,
    }

    if $log_dir == undef {
      $admin_nodemanager_log_dir = "${domain_dir}/${domain_name}/servers/${adminserver_name}/logs"
      $nodemanager_log_dir       = "${domain_dir}/${domain_name}/nodemanager/nodemanager.log"

    } else {
      $admin_nodemanager_log_dir = $log_dir
      $nodeMgrLogDir             = "${log_dir}/nodemanager_${domain_name}.log"

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
      mode    => 0775,
      owner   => $os_user,
      group   => $os_group,
    }

    # make the default domain folders
    if !defined(File["${middleware_home_dir}/user_projects"]) {
      # check oracle install folder
      file { "${middleware_home_dir}/user_projects":
        ensure  => directory,
        recurse => false,
        replace => false,
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
      }
    }

    if !defined(File["${middleware_home_dir}/user_projects/domains"]) {
      # check oracle install folder
      file { "${middleware_home_dir}/user_projects/domains":
        ensure  => directory,
        recurse => false,
        replace => false,
        require => File["${middleware_home_dir}/user_projects"],
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
      }
    }

    if !defined(File["${middleware_home_dir}/user_projects/applications"]) {
      # check oracle install folder
      file { "${middleware_home_dir}/user_projects/applications":
        ensure  => directory,
        recurse => false,
        replace => false,
        mode    => 0775,
        owner   => $os_user,
        group   => $os_group,
        require => File["${middleware_home_dir}/user_projects"],
      }
    }

    $packCommand = "-domain=${domain_dir}/${domain_name} -template=${download_dir}/domain_${domain_name}.jar -template_name=domain_${domain_name} -log=${download_dir}/domain_${domain_name}.log -log_priority=INFO"

    exec { "execwlst ${domain_name} ${title}":
      command     => "${wlstPath}/wlst.sh ${download_dir}/domain_${domain_name}.py",
      environment => ["JAVA_HOME=${JAVA_HOME}"],
      unless      => "/usr/bin/test -e ${domain_dir}/${domain_name}",
      creates     => "${domain_dir}/${domain_name}",
      require     => [
        File["domain.py ${domain_name} ${title}"],
        File["${middleware_home_dir}/user_projects/domains"],
        File["${middleware_home_dir}/user_projects/applications"]],
      timeout     => 0,
      path        => $exec_path,
      user        => $os_user,
      group       => $os_group,
    }

    exec { "setDebugFlagOnFalse ${domain_name} ${title}":
      command => "sed -i -e's/debugFlag=\"true\"/debugFlag=\"false\"/g' ${domain_dir}/${domain_name}/bin/setDomainEnv.sh",
      onlyif  => "/bin/grep debugFlag=\"true\" ${domain_dir}/${domain_name}/bin/setDomainEnv.sh | /usr/bin/wc -l",
      require => Exec["execwlst ${domain_name} ${title}"],
      path    => $exec_path,
      user    => $os_user,
      group   => $os_group,
    }

    exec { "domain.py ${domain_name} ${title}":
      command => "rm -I ${download_dir}/domain_${domain_name}.py",
      require => Exec["execwlst ${domain_name} ${title}"],
      path    => $exec_path,
      user    => $os_user,
      group   => $os_group,
    }

    exec { "pack domain ${domain_name} ${title}":
      command => "${weblogic_home_dir}/common/bin/pack.sh ${packCommand}",
      require => Exec["setDebugFlagOnFalse ${domain_name} ${title}"],
      creates => "${download_dir}/domain_${domain_name}.jar",
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
