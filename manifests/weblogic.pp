# == Class: orawls::weblogic
#
class orawls::weblogic (
  $version              = 1111,  # 1036|1111|1211|1212|1213|1221
  $filename             = undef, # wls1036_generic.jar|wls1211_generic.jar|wls_121200.jar|wls_121300.jar|oepe-wls-indigo-installer-11.1.1.8.0.201110211138-10.3.6-linux32.bin
  $oracle_base_home_dir = undef, # /opt/oracle
  $middleware_home_dir  = undef, # /opt/oracle/middleware11gR1
  $weblogic_home_dir    = undef, # /opt/oracle/middleware11gR1/wlserver
  $wls_domains_dir      = undef, # /opt/oracle/wlsdomains/domains
  $wls_apps_dir         = undef, # /opt/oracle/wlsdomains/applications
  $fmw_infra            = false, # true|false 1212/1213/1221 option -> plain weblogic or fmw infra
  $jdk_home_dir         = undef, # /usr/java/jdk1.7.0_45
  $os_user              = undef, # oracle
  $os_group             = undef, # dba
  $download_dir         = undef, # /data/install
  $source               = undef, # puppet:///modules/orawls/ | /mnt | /vagrant
  $remote_file          = true,  # true|false
  $java_parameters      = '',    # '-Dspace.detection=false'
  $log_output           = false, # true|false
  $temp_directory       = '/tmp',# /tmp temporay directory for files extractions
) {

  ::orawls::weblogic_type{'base':
    version              => $version,
    filename             => $filename,
    oracle_base_home_dir => $oracle_base_home_dir,
    middleware_home_dir  => $middleware_home_dir,
    weblogic_home_dir    => $weblogic_home_dir,
    wls_domains_dir      => $wls_domains_dir,
    wls_apps_dir         => $wls_apps_dir,
    fmw_infra            => $fmw_infra,
    jdk_home_dir         => $jdk_home_dir,
    os_user              => $os_user,
    os_group             => $os_group,
    download_dir         => $download_dir,
    source               => $source,
    remote_file          => $remote_file,
    java_parameters      => $java_parameters,
    log_output           => $log_output,
    temp_directory       => $temp_directory,
  }
}
