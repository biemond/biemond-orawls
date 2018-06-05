# 
# weblogic installation class
#
# Will install a WebLogic Middleware home on a VM, For multiple middleware home use the weblogic_type define
#
# @example Declaring the class
#   class{'orawls::weblogic':
#     version                   => 12212,
#     filename                  => 'fmw_12.2.1.2.0_wls.jar',
#     jdk_home_dir              => '/usr/java/latest',
#     ora_inventory_dir         => '/opt/oracle',
#     oracle_base_home_dir      => "/opt/oracle",
#     middleware_home_dir       => "/opt/oracle/middleware12c",
#     weblogic_home_dir         => "/opt/oracle/middleware12c/wlserver",
#     download_dir              => "/var/tmp/install",
#     puppet_download_mnt_point => "/software",
#     log_output                => true,
#     remote_file               => false
#     wls_domains_dir           => '/opt/oracle/wlsdomains//domains',
#     wls_apps_dir              => '/opt/oracle/wlsdomains/applications',
#   }
# 
# @param version Weblogic version like 1036, 1111, 1213 or 12212
# @param filename the weblogic jar file like wls1036_generic.jar or fmw_12.2.1.2.0_wls.jar
# @param ora_inventory_dir full path to the Oracle Inventory location directory. If not specfied, it defaults to oracle_base_home_dir (for example /opt/oracle or /u01/app/oracle). If you use the biemond-oradb module, you must set it to oracle_base_home_dir/.. (for example /opt or /u01/app)
# @param oracle_base_home_dir base directory of the oracle installation, it will contain the default Oracle inventory and the middleware home
# @param middleware_home_dir directory of the Oracle software inside the oracle base directory
# @param weblogic_home_dir directory of the WebLogic software inside the middleware directory
# @param wls_domains_dir root directory for all the WebLogic domains
# @param wls_apps_dir root directory for all the domain apps
# @param fmw_infra should install the WebLogic 12c infrastructure edition, you cannot use the normal wls install jar
# @param jdk_home_dir full path to the java home directory like /usr/java/default
# @param os_user the user name with oracle as default
# @param os_group the group name with dba as default
# @param download_dir the directory for temporary created by this class
# @param puppet_download_mnt_point the location of the filename like puppet:///modules/orawls/ or /software
# @param remote_file to control if the filename is already accessiable on the VM 
# @param java_parameters provide additional parameters to the WebLogic Installation
# @param log_output show all the output of the the exec actions
# @param temp_dir override the default temp directory /tmp
# @param validation ignore validation all the errrors
# @param force force the installation of WebLogic
# @param orainstpath_dir the location of orainst.loc, default it will the default directory for Linux or Solaris
#
class orawls::weblogic (
  Integer $version                    = lookup('orawls::default_version'),
  String $filename                    = undef,
  Optional[String] $ora_inventory_dir = undef, # /opt/oracle
  String $oracle_base_home_dir        = undef, # /opt/oracle
  String $middleware_home_dir         = undef, # /opt/oracle/middleware11gR1
  Optional[String] $weblogic_home_dir = undef, # /opt/oracle/middleware11gR1/wlserver
  Optional[String] $wls_domains_dir   = undef, # /opt/oracle/wlsdomains/domains
  Optional[String] $wls_apps_dir      = undef, # /opt/oracle/wlsdomains/applications
  Boolean $fmw_infra                  = false, # plain weblogic or fmw infra
  String $jdk_home_dir                = undef, # /usr/java/jdk1.7.0_45
  String $os_user                     = lookup('orawls::user'),
  String $os_group                    = lookup('orawls::group'),
  String $download_dir                = lookup('orawls::download_dir'),
  String $puppet_download_mnt_point   = lookup('orawls::module_mountpoint'),
  Boolean $remote_file                = true,
  String $java_parameters             = '', # '-Dspace.detection=false'
  Boolean $log_output                 = false,
  String $temp_dir                    = lookup('orawls::tmp_dir'),# /tmp temporary directory for files extractions
  Boolean $validation                 = true,
  Boolean $force                      = false,
  String $orainstpath_dir             = lookup('orawls::orainst_dir'),
)
{

  orawls::weblogic_type{'base':
    version                   => $version,
    filename                  => $filename,
    ora_inventory_dir         => $ora_inventory_dir,
    oracle_base_home_dir      => $oracle_base_home_dir,
    middleware_home_dir       => $middleware_home_dir,
    weblogic_home_dir         => $weblogic_home_dir,
    wls_domains_dir           => $wls_domains_dir,
    wls_apps_dir              => $wls_apps_dir,
    fmw_infra                 => $fmw_infra,
    jdk_home_dir              => $jdk_home_dir,
    os_user                   => $os_user,
    os_group                  => $os_group,
    download_dir              => $download_dir,
    puppet_download_mnt_point => $puppet_download_mnt_point,
    remote_file               => $remote_file,
    java_parameters           => $java_parameters,
    log_output                => $log_output,
    temp_dir                  => $temp_dir,
    validation                => $validation,
    force                     => $force,
    orainstpath_dir           => $orainstpath_dir,
  }

}
