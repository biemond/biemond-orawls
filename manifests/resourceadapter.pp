#
#
define orawls::resourceadapter( 
  $middleware_home_dir       = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $weblogic_home_dir         = hiera('wls_weblogic_home_dir'),
  $jdk_home_dir              = hiera('wls_jdk_home_dir'), # /usr/java/jdk1.7.0_45
  $wls_domains_dir           = hiera('wls_domains_dir'           , undef),
  $domain_name               = hiera('domain_name'               , undef),
  $adapter_name              = undef,
  $adapter_path              = undef,
  $adapter_plan_dir          = undef,
  $adapter_plan              = undef,
  $adapter_entry             = undef,
  $adapter_entry_property    = undef,
  $adapter_entry_value       = undef,
  $adminserver_address       = hiera('domain_adminserver_address', "localhost"),
  $adminserver_port          = hiera('domain_adminserver_port'   , 7001),
  $userConfigFile            = hiera('domain_user_config_file'   , undef),
  $userKeyFile               = hiera('domain_user_key_file'      , undef),
  $weblogic_user             = hiera('wls_weblogic_user'         , "weblogic"),
  $weblogic_password         = hiera('domain_wls_password'       , undef),
  $os_user                   = hiera('wls_os_user'), # oracle
  $os_group                  = hiera('wls_os_group'), # dba
  $download_dir              = hiera('wls_download_dir'), # /data/install
  $log_output                = false, # true|false
) 
{

  if ( $wls_domains_dir == undef ) {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir 
  }

  $domain_dir = "${domains_dir}/${domain_name}"

  # if these params are empty always continue
  if $domain_name == undef or $adapter_name == undef or $adapter_plan_dir == undef or $adapter_plan == undef {
    fail("domain, adapter_name,adapter_plan_dir or adapter_plan is nill")
  } else {
    # check if the object already exists on the weblogic domain
    $found = artifact_exists($domain_dir ,"resource",$adapter_name,"${adapter_plan_dir}/${adapter_plan}" )
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
    fail("domain, adapter_name or adapter_entry is nill")
  } else {
    # check if the object already exists on the weblogic domain
    $foundEntry = artifact_exists($domain_dir ,"resource_entry",$adapter_name,$adapter_entry )
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
    fail("userConfigFile or wlsUser parameter is empty ")
  }

  # lets make the a new plan for this adapter
  if ( $continuePlan ) {

    # download the plan and put it on the right place
    if $adapter_name == 'DbAdapter' {
      file { "${adapter_plan_dir}/${adapter_plan}":
        ensure  => present,
        mode    => '0744',
        owner   => $os_user,
        group   => $os_group,
        backup  => false,
        path    => "${adapter_plan_dir}/${adapter_plan}",
        content => template("orawls/adapter_plans/Plan_DB.xml.erb"),
        before  => Exec["exec deployer adapter plan ${title}"],
      }
    } elsif $adapter_name == 'JmsAdapter' {
      file { "${adapter_plan_dir}/${adapter_plan}":
        ensure  => present,
        mode    => '0744',
        owner   => $os_user,
        group   => $os_group,
        backup  => false,
        path    => "${adapter_plan_dir}/${adapter_plan}",
        content => template("orawls/adapter_plans/Plan_JMS.xml.erb"),
        before  => Exec["exec deployer adapter plan ${title}"],
      }
    } elsif $adapter_name == 'AqAdapter' {
      file { "${adapter_plan_dir}/${adapter_plan}":
        ensure  => present,
        mode    => '0744',
        owner   => $os_user,
        group   => $os_group,
        backup  => false,
        path    => "${adapter_plan_dir}/${adapter_plan}",
        content => template("orawls/adapter_plans/Plan_AQ.xml.erb"),
        before  => Exec["exec deployer adapter plan ${title}"],
      }
    } else {
      fail("adapter_name ${adapter_name} is unknown, choose for DbAdapter,JmsAdapter or AqAdapter ")
    }

    case $::kernel {
      'Linux': {
        $java_statement = "java weblogic.Deployer"
      }
      'SunOS': {
        $java_statement = "java -d64 weblogic.Deployer"
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
        }

      }
    }
  }

  # after deployment of the plan we can add a new entry to the adapter
  if ( $continueEntry ) {

    if $adapter_name == 'DbAdapter' or $adapter_name == 'AqAdapter'  {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
    } elsif $adapter_name == 'JmsAdapter' {
      $connectionFactoryInterface='oracle.tip.adapter.jms.IJmsConnectionFactory'
    }

    case $::kernel {
      'Linux': {
        $javaCommandPlan = "java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning "
      }
      'SunOS': {
        $javaCommandPlan = "java -d64 -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning "
      }
    }

    file { "${download_dir}/${title}redeployResourceAdapter.py":
      ensure  => present,
      mode    => '0744',
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
      path    => "${download_dir}/${title}redeployResourceAdapter.py",
      content => template("orawls/adapter_plans/redeployResourceAdapter.py.erb"),
      before  => Exec["exec redeploy adapter plan ${title}"],
    }

    file { "${download_dir}/${title}createResourceAdapterEntry.py":
      ensure  => present,
      mode    => '0744',
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
      path    => "${download_dir}/${title}createResourceAdapterEntry.py",
      content => template("orawls/adapter_plans/createResourceAdapterEntry.py.erb"),
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
          require     => Exec["exec create resource adapter entry ${title}"],
        }

      }
    }
  }
}
