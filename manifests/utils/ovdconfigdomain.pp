#
# utils::ovdconfigdomain define
#
# Does all the Oracle Identity Management configuration for OVD. Extends an ADF domain for OVD.
#
# @param version used weblogic software like 1036
# @param ovd_instance_name The name of the OVD instance
# @param ovd_ldap_namespace LDAP Distinguish Names namespace
# @param ovd_admin The ovd administrator username
# @param wls_domains_dir root directory for all the WebLogic domains
# @param middleware_home_dir directory of the Oracle software inside the oracle base directory
# @param domain_name the domain name which to create
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
# @param adminserver_name WebLogic AdminServer name
# @param nodemanager_port the port number of the used NodeManager
#
define orawls::utils::ovdconfigdomain(
  Integer $version                                        = undef,
  String $ovd_instance_name                               = undef,
  String $ovd_ldap_namespace                              = 'dc=us,dc=oracle,dc=com',
  String $ovd_admin                                       = 'cn=orcladmin',
  String $weblogic_home_dir                               = $::orawls::weblogic::weblogic_home_dir,
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir,
  String $jdk_home_dir                                    = $::orawls::weblogic::jdk_home_dir,
  Optional[String] $wls_domains_dir                       = $::orawls::weblogic::wls_domains_dir,
  String $domain_name                                     = undef,
  String $adminserver_name                                = 'AdminServer',
  String $adminserver_address                             = 'localhost',
  Integer $adminserver_port                               = 7001,
  String $weblogic_user                                   = 'weblogic',
  String $weblogic_password                               = undef,
  String $os_user                                         = $::orawls::weblogic::os_user,
  String $os_group                                        = $::orawls::weblogic::os_group,
  String $download_dir                                    = $::orawls::weblogic::download_dir,
  Boolean $log_output                                     = $::orawls::weblogic::log_output,
)
{
  if ( $wls_domains_dir == undef or $wls_domains_dir == '') {
    $domains_dir = "${middleware_home_dir}/user_projects/domains"
  } else {
    $domains_dir =  $wls_domains_dir
  }

  $domain_dir = "${domains_dir}/${domain_name}"
  $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

  $ovd_home = "${middleware_home_dir}/Oracle_IDM1"

  if $version != 1111 {
    fail('11.1.1.9 is only supported for OVD.')
  }

  file { "${download_dir}/${title}config_ovd_server.rsp":
    ensure  => present,
    content => epp('orawls/ovd/im_config_only.rsp.epp', {
      'weblogic_home_dir'   => $weblogic_home_dir,
      'middleware_home_dir' => $middleware_home_dir,
      'adminserver_address' => $adminserver_address,
      'adminserver_port'    => $adminserver_port,
      'weblogic_user'       => $weblogic_user,
      'weblogic_password'   => $weblogic_password,
      'domain_name'         => $domain_name,
      'ovd_instance_name'   => $ovd_instance_name,
      'ovd_ldap_namespace'  => $ovd_ldap_namespace,
      'ovd_admin'           => $ovd_admin,
    }),
    mode    => '0775',
    owner   => $os_user,
    group   => $os_group,
    backup  => false,
  }

  exec { "create and config ovd domain ${title}":
    command   => "/bin/sh -c 'unset DISPLAY;${ovd_home}/bin/config.sh -silent -response ${download_dir}/${title}config_ovd_server.rsp -waitforcompletion -debug -logLevel fine'",
    timeout   => 0,
    require   => File["${download_dir}/${title}config_ovd_server.rsp"],
    creates   => "${middleware_home_dir}/${ovd_instance_name}",
    path      => $exec_path,
    user      => $os_user,
    group     => $os_group,
    logoutput => true,
  }

}

