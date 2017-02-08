# == Class: orawls::weblogic
#
class orawls::weblogic (
  Integer $version                    = lookup('orawls::default_version'),
  String $filename                    = undef, # wls1036_generic.jar|wls1211_generic.jar|wls_121200.jar|wls_121300.jar|oepe-wls-indigo-installer-11.1.1.8.0.201110211138-10.3.6-linux32.bin
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
  String $puppet_download_mnt_point   = lookup('orawls::module_mountpoint'), # puppet:///modules/orawls/ | /mnt | /vagrant
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
