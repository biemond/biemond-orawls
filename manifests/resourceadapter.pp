#
# resourceadapter define
#
# configure a SOA/OSB resource adapter
#
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
define orawls::resourceadapter(
  String $weblogic_home_dir                   = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir                 = $::orawls::weblogic::middleware_home_dir,
  String $jdk_home_dir                        = $::orawls::weblogic::jdk_home_dir,
  String $wls_domains_dir                     = $::orawls::weblogic::wls_domains_dir,
  String $domain_name                         = undef,
  String $os_user                             = $::orawls::weblogic::os_user,
  String $os_group                            = $::orawls::weblogic::os_group,
  String $download_dir                        = $::orawls::weblogic::download_dir,
  Boolean $log_output                         = $::orawls::weblogic::log_output,
  String $adapter_name                        = undef,
  String $adapter_path                        = undef,
  String $adapter_plan_dir                    = undef,
  String $adapter_plan                        = undef,
  String $adapter_entry                       = undef,
  String $adapter_entry_property              = undef,
  String $adapter_entry_value                 = undef,
  Optional[String] $adminserver_address       = 'localhost',
  Integer $adminserver_port                   = 7001,
  Optional[String] $userConfigFile            = undef,
  Optional[String] $userKeyFile               = undef,
  String $weblogic_user                       = 'weblogic',
  String $weblogic_password                   = undef,
)
{

  if ( $wls_domains_dir == undef or $wls_domains_dir == '') {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  $domain_dir = "${domains_dir}/${domain_name}"

  # check if the object already exists on the weblogic domain
  $found = orawls::resource_adapter_exists($domain_dir,'resource',$adapter_name,"${adapter_plan_dir}/${adapter_plan}" )
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


  # check if the object already exists on the weblogic domain
  $foundEntry = orawls::resource_adapter_exists($domain_dir ,'resource_entry',$adapter_name,$adapter_entry )
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

  $execPath = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

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
          mode    => lookup('orawls::permissions_group_restricted'),
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => epp('orawls/adapter_plans/Plan_JMS.xml.epp', { 'adapter_plan_dir' => $adapter_plan_dir }),
        }
      }
    }
    'DbAdapter' : {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => lookup('orawls::permissions_group_restricted'),
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => epp('orawls/adapter_plans/Plan_DB.xml.epp', { 'adapter_plan_dir' => $adapter_plan_dir }),
        }
      }
    }
    'AqAdapter' : {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => lookup('orawls::permissions_group_restricted'),
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => epp('orawls/adapter_plans/Plan_AQ.xml.epp', { 'adapter_plan_dir' => $adapter_plan_dir }),
        }
      }
    }
    'FtpAdapter' : {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => lookup('orawls::permissions_group_restricted'),
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => epp('orawls/adapter_plans/Plan_FTP.xml.epp', { 'adapter_plan_dir' => $adapter_plan_dir }),
        }
      }
    }
    'FileAdapter' : {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => lookup('orawls::permissions_group_restricted'),
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => epp('orawls/adapter_plans/Plan_File.xml.epp', { 'adapter_plan_dir' => $adapter_plan_dir }),
        }
      }
    }
    'MQSeriesAdapter' : {
      $connectionFactoryInterface='javax.resource.cci.ConnectionFactory'
      if !defined(File["${adapter_plan_dir}/${adapter_plan}"]) {
        file { "${adapter_plan_dir}/${adapter_plan}":
          ensure  => present,
          mode    => lookup('orawls::permissions_group_restricted'),
          replace => false,
          owner   => $os_user,
          group   => $os_group,
          backup  => false,
          path    => "${adapter_plan_dir}/${adapter_plan}",
          content => epp('orawls/adapter_plans/Plan_MQSeries.xml.epp', { 'adapter_plan_dir' => $adapter_plan_dir }),
        }
      }
    }
    default: {
      fail("adapter_name ${adapter_name} is unknown, choose FileAdapter, DbAdapter, JmsAdapter, FtpAdapter, MQSeriesAdapter or AqAdapter ")
    }
  }

  # lets make the a new plan for this adapter
  if ( $continuePlan ) {

    $java_statement = "${lookup('orawls::java')} weblogic.Deployer"

    case $facts['kernel'] {
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
    # $javaCommandPlan = "${lookup('orawls::java')} -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning "
    $javaCommandPlan = "${middleware_home_dir}/oracle_common/common/bin/wlst.sh "

    file { "${download_dir}/${title}redeployResourceAdapter.py":
      ensure  => present,
      mode    => lookup('orawls::permissions_group_restricted'),
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
      path    => "${download_dir}/${title}redeployResourceAdapter.py",
      content => epp('orawls/adapter_plans/redeployResourceAdapter.py.epp',{
                      'weblogic_user'       => $weblogic_user,
                      'adminserver_address' => $adminserver_address,
                      'adminserver_port'    => $adminserver_port,
                      'userConfigFile'      => $userConfigFile,
                      'userKeyFile'         => $userKeyFile,
                      'useStoreConfig'      => $useStoreConfig,
                      'adapter_name'        => $adapter_name,
                      'adapter_plan_dir'    => $adapter_plan_dir,
                      'adapter_plan'        => $adapter_plan }),
      before  => Exec["exec redeploy adapter plan ${title}"],
    }

    file { "${download_dir}/${title}createResourceAdapterEntry.py":
      ensure  => present,
      mode    => lookup('orawls::permissions_group_restricted'),
      owner   => $os_user,
      group   => $os_group,
      backup  => false,
      path    => "${download_dir}/${title}createResourceAdapterEntry.py",
      content => epp('orawls/adapter_plans/createResourceAdapterEntry.py.epp', {
                      'weblogic_user'              => $weblogic_user,
                      'adminserver_address'        => $adminserver_address,
                      'adminserver_port'           => $adminserver_port,
                      'userConfigFile'             => $userConfigFile,
                      'userKeyFile'                => $userKeyFile,
                      'useStoreConfig'             => $useStoreConfig,
                      'adapter_entry'              => $adapter_entry,
                      'adapter_entry_value'        => $adapter_entry_value,
                      'adapter_entry_property'     => $adapter_entry_property,
                      'connectionFactoryInterface' => $connectionFactoryInterface,
                      'adapter_name'               => $adapter_name,
                      'adapter_path'               => $adapter_path,
                      'adapter_plan_dir'           => $adapter_plan_dir,
                      'adapter_plan'               => $adapter_plan }),
      before  => Exec["exec create resource adapter entry ${title}"],
    }


    case $facts['kernel'] {
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
