#
#
define orawls::resourceadapter(
  $domain_name,
  $adapter_name              = undef,
  $adapter_path              = undef,
  $adapter_plan_dir          = undef,
  $adapter_plan              = undef,
  $adapter_entry             = undef,
  $adapter_entry_property    = undef,
  $adapter_entry_value       = undef,
  $adminserver_address       = 'localhost',
  $adminserver_port          = 7001,
  $userConfigFile            = undef,
  $userKeyFile               = undef,
  $weblogic_user             = 'weblogic',
  $weblogic_password         = undef,
)
{
  $version              = $::orawls::weblogic::version
  $middleware_home_dir  = $::orawls::weblogic::middleware_home_dir
  $weblogic_home_dir    = $::orawls::weblogic::weblogic_home_dir
  $wls_domains_dir      = $::orawls::weblogic::wls_domains_dir
  $wls_apps_dir         = $::orawls::weblogic::wls_apps_dir
  $jdk_home_dir         = $::orawls::weblogic::jdk_home_dir
  $os_user              = $::orawls::weblogic::os_user
  $os_group             = $::orawls::weblogic::os_group
  $download_dir         = $::orawls::weblogic::download_dir
  $log_output           = $::orawls::weblogic::log_output
  $oracle_base_home_dir = $::orawls::weblogic::oracle_base_home_dir
  $source               = $::orawls::weblogic::source
  $temp_directory       = $::orawls::weblogic::temp_directory

  if ( $wls_domains_dir == undef or $wls_domains_dir == '') {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  $domain_dir = "${domains_dir}/${domain_name}"

  # if these params are empty always continue
  if $domain_name == undef or $adapter_name == undef or $adapter_plan_dir == undef or $adapter_plan == undef {
    fail('domain, adapter_name,adapter_plan_dir or adapter_plan is nill')
  } else {
    # check if the object already exists on the weblogic domain
    $found = artifact_exists($domain_dir,'resource',$adapter_name,"${adapter_plan_dir}/${adapter_plan}" )
    if $found == undef {
      $continuePlan = true
      notify {"wls::resourceadapter ${title} continue cause nill":}
    } else {
      if ( $found ) {
        $continuePlan = false
      } else {
        notify {"wls::resourceadapter ${title} continue, does not exists":}
        $continuePlan = true
      }
    }
  }

  # if these params are empty always continue
  if $domain_name == undef or $adapter_name == undef or $adapter_entry == undef {
    fail('domain, adapter_name or adapter_entry is nill')
  } else {
    # check if the object already exists on the weblogic domain
    $foundEntry = artifact_exists($domain_dir ,'resource_entry',$adapter_name,$adapter_entry )
    if $foundEntry == undef {
      $continueEntry = true
      notify {"wls::resourceadapter entry ${adapter_entry} ${title} continue cause nill":}
    } else {
      if ( $foundEntry ) {
        $continueEntry = false
      } else {
        notify {"wls::resourceadapter entry ${adapter_entry} ${title} continue, does not exists":}
        $continueEntry = true
      }
    }
  }

  $execPath = "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

  # are we using credentials or using the WLST userConfig file
  if $userConfigFile != undef {
    $credentials    =   " -userconfigfile ${userConfigFile} -userkeyfile ${userKeyFile}"
    $useStoreConfig = true
  } elsif $weblogic_user != undef {
    $credentials =   " -user ${weblogic_user} -password ${weblogic_password}"
    $useStoreConfig = false
  } else {
    fail('userConfigFile or wlsUser parameter is empty')
  }

  case $adapter_name {
    'JmsAdapter':{
      $connectionFactoryInterface='oracle.tip.adapter.jms.IJmsConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => '0744',
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => template('orawls/adapter_plans/Plan_JMS.xml.erb'),
        }
      }
    }
    'DbAdapter' : {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => '0744',
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => template('orawls/adapter_plans/Plan_DB.xml.erb'),
        }
      }
    }
    'AqAdapter' : {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => '0744',
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => template('orawls/adapter_plans/Plan_AQ.xml.erb'),
        }
      }
    }
    'FtpAdapter' : {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => '0744',
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => template('orawls/adapter_plans/Plan_FTP.xml.erb'),
        }
      }
    }
    'FileAdapter' : {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => '0744',
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => template('orawls/adapter_plans/Plan_File.xml.erb'),
        }
      }
    }
    'MQSeriesAdapter' : {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => '0744',
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => template('orawls/adapter_plans/Plan_MQSeries.xml.erb'),
        }
      }
    }
    default: {
      fail("adapter_name ${adapter_name} is unknown, choose FileAdapter, DbAdapter, JmsAdapter, FtpAdapter, MQSeriesAdapter or AqAdapter ")
    }
  }

  # lets make the a new plan for this adapter
  if ( $continuePlan ) {

    case $::kernel {
      'Linux': {
        $java_statement = 'java weblogic.Deployer'
      }
      'SunOS': {
        $java_statement = 'java -d64 weblogic.Deployer'
      }
    }

    case $::kernel {
      'Linux','SunOS': {
        # deploy the plan and update the adapter
        exec { "exec deployer adapter plan ${title}":
          command     => "${java_statement} -adminurl t3://${adminserver_address}:${adminserver_port} ${credentials} -update -name ${adapter_name} -plan ${adapter_plan_dir}/${adapter_plan}",
          environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
          "JAVA_HOME=${jdk_home_dir}"],
          path        => $execPath,
          user        => $os_user,
          group       => $os_group,
          logoutput   => $log_output,
          require     => File["${adapter_plan_dir}/${adapter_plan}"],
          before      => Exec["exec create resource adapter entry ${title}"],
        }

      }
    }
  }

  # after deployment of the plan we can add a new entry to the adapter
  if ( $continueEntry ) {
    case $::kernel {
      'Linux': {
        $javaCommandPlan = 'java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning '
      }
      'SunOS': {
        $javaCommandPlan = 'java -d64 -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning '
      }
    }

    file { "${download_dir}/${title}redeployResourceAdapter.py":
      ensure  => present,
      mode    => '0744',
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
      path    => "${download_dir}/${title}redeployResourceAdapter.py",
      content => template('orawls/adapter_plans/redeployResourceAdapter.py.erb'),
      before  => Exec["exec redeploy adapter plan ${title}"],
    }

    file { "${download_dir}/${title}createResourceAdapterEntry.py":
      ensure  => present,
      mode    => '0744',
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
      path    => "${download_dir}/${title}createResourceAdapterEntry.py",
      content => template('orawls/adapter_plans/createResourceAdapterEntry.py.erb'),
      before  => Exec["exec create resource adapter entry ${title}"],
    }


    case $::kernel {
      'Linux','SunOS': {
        # deploy the plan and update the adapter
        exec { "exec create resource adapter entry ${title}":
          command     => "${javaCommandPlan} ${download_dir}/${title}createResourceAdapterEntry.py ${weblogic_password}",
          environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
          "JAVA_HOME=${jdk_home_dir}"],
          path        => $execPath,
          user        => $os_user,
          group       => $os_group,
          logoutput   => $log_output,
          require     => File["${adapter_plan_dir}/${adapter_plan}"],
        }

        # deploy the plan and update the adapter
        exec { "exec redeploy adapter plan ${title}":
          command     => "${javaCommandPlan} ${download_dir}/${title}redeployResourceAdapter.py ${weblogic_password}",
          environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar",
          "JAVA_HOME=${jdk_home_dir}"],
          path        => $execPath,
          user        => $os_user,
          group       => $os_group,
          logoutput   => $log_output,
          require     => [Exec["exec create resource adapter entry ${title}"],File["${adapter_plan_dir}/${adapter_plan}"],],
        }

      }
    }
  }
}
