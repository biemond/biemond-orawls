#
# utils::reportscomponents define
#
# Add a report component into Oracle Forms and Reports 12c
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
# @param action_name create or delete
# @param instance_name
# @param machine_name
# @param component_type
#
define orawls::utils::reportscomponents(
  Integer $version                                        = $::orawls::weblogic::version,
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir,
  String $jdk_home_dir                                    = $::orawls::weblogic::jdk_home_dir,
  String $domain_name                                     = undef,
  Optional[String] $wls_domains_dir                       = $::orawls::weblogic::wls_domains_dir,
  String $adminserver_address                             = 'localhost',
  Integer $adminserver_port                               = 7001,
  Enum['create','delete'] $action_name                    = 'create',
  Enum['bridge','server', 'tools'] $component_type        = undef,
  String $instance_name                                   = undef,
  String $machine_name                                    = undef,
  String $weblogic_user                                   = 'weblogic',
  String $weblogic_password                               = undef,
  String $os_user                                         = $::orawls::weblogic::os_user,
  String $os_group                                        = $::orawls::weblogic::os_group,
  String $download_dir                                    = $::orawls::weblogic::download_dir,
  Boolean $log_output                                     = $::orawls::weblogic::log_output,
){

  if ( $wls_domains_dir == undef ) {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }
  $domain_dir = "${domains_dir}/${domain_name}"

  $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

  if $component_type == 'bridge' {
    $sys_component_dir = 'ReportsBridgeComponent'
  } 
  elsif $component_type == 'server' {
    $sys_component_dir = 'ReportsServerComponent'
  }
  elsif $component_type == 'tools' {
    $sys_component_dir = 'ReportsToolsComponent'
  }
  else {
    fail("Invalid component_type: ${component_type}")
  } 

  if ( $version == 1212 or $version == 1213 or $version >= 1221 ){

    if $action_name == 'create' {

      file { "${download_dir}/${title}_reportsComponent.py":
        ensure  => present,
        content => template('orawls/wlst/wlstexec/fmw/createReportsComponent.py.erb'),
        backup  => false,
        replace => true,
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
      }

      exec { "execwlst reportscomponent ${title}":
        command     => "${middleware_home_dir}/oracle_common/common/bin/wlst.sh ${download_dir}/${title}_reportsComponent.py \'${weblogic_password}\'",
        environment => ["JAVA_HOME=${jdk_home_dir}"],
        path        => $exec_path,
        creates     => "${domain_dir}/config/fmwconfig/components/${sys_component_dir}/${instance_name}",
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => File["${download_dir}/${title}_reportsComponent.py"],
      }    

    } else {

      file { "${download_dir}/${title}_reportsComponent.py":
        ensure  => present,
        content => template('orawls/wlst/wlstexec/fmw/createReportsComponent.py.erb'),
        backup  => false,
        replace => true,
        mode    => '0775',
        owner   => $os_user,
        group   => $os_group,
      }

      exec { "execwlst reportscomponent ${title}":
        command     => "${middleware_home_dir}/oracle_common/common/bin/wlst.sh ${download_dir}/${title}_reportsComponent.py \'${weblogic_password}\'",
        environment => ["JAVA_HOME=${jdk_home_dir}"],
        path        => $exec_path,
        onlyif      => "test -d  ${domain_dir}/config/fmwconfig/components/${sys_component_dir}/${instance_name}",
        user        => $os_user,
        group       => $os_group,
        logoutput   => $log_output,
        require     => File["${download_dir}/${title}_reportsComponent.py"],
      }

    }

  } else {
    fail("${version} not supported for orawls::utils::reportscomponents")
  }

}
