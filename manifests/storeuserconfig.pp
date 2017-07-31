# 
# storeuserconfig define
#
# Will store the weblogic credentials on the VM so it can be used by others operations without providing the credentials
#
# @example Declaring the class
#   orawls::storeuserconfig{'domainA':
#     domain_name               => 'domainA',
#     user_config_dir           => '/home/oracle',
#     weblogic_password         => 'weblogic1',
#   }
# 
# @param domain_name the domain name which to connect to
# @param adminserver_address the adminserver network name or ip
# @param adminserver_port the adminserver port number
# @param user_config_dir the full path to write the userconfig credentials
# @param weblogic_user the weblogic administrator username
# @param weblogic_password the weblogic domain password
# @param weblogic_home_dir directory of the WebLogic software inside the middleware directory
# @param jdk_home_dir full path to the java home directory like /usr/java/default
# @param os_user the user name with oracle as default
# @param os_group the group name with dba as default
# @param download_dir the directory for temporary created by this class
# @param log_output show all the output of the the exec actions
#
define orawls::storeuserconfig (
  String $domain_name                  = undef,
  String $weblogic_home_dir            = $::orawls::weblogic::weblogic_home_dir,
  String $jdk_home_dir                 = $::orawls::weblogic::jdk_home_dir,
  String $adminserver_address          = 'localhost',
  Integer $adminserver_port            = 7001,
  Boolean $adminserver_secure_listener = false,
  String $user_config_dir              = undef,
  String $weblogic_user                = 'weblogic',
  String $weblogic_password            = undef,
  String $os_user                      = $::orawls::weblogic::os_user,
  String $os_group                     = $::orawls::weblogic::os_group,
  String $download_dir                 = $::orawls::weblogic::download_dir,
  Boolean $log_output                  = $::orawls::weblogic::log_output,
)
{
  # the py script used by the wlst*-
  file { "${download_dir}/${title}storeUserConfig.py":
    ensure  => present,
    path    => "${download_dir}/${title}storeUserConfig.py",
    content => epp('orawls/wlst/storeUserConfig.py.epp', {
                    'weblogic_user'               => $weblogic_user,
                    'adminserver_address'         => $adminserver_address,
                    'adminserver_port'            => $adminserver_port,
                    'adminserver_secure_listener' => $adminserver_secure_listener,
                    'domain_name'                 => $domain_name,
                    'os_user'                     => $os_user,
                    'user_config_dir'             => $user_config_dir }),
    backup  => false,
    replace => true,
    mode    => '0555',
    owner   => $os_user,
    group   => $os_group,
  }

  $javaCommand = 'java -Dweblogic.management.confirmKeyfileCreation=true -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning '
  $exec_path = "${jdk_home_dir}/bin:${lookup('orawls::exec_path')}"

  exec { "execwlst ${title}storeUserConfig.py":
    command     => "${javaCommand} ${download_dir}/${title}storeUserConfig.py \'${weblogic_password}\'",
    environment => ["CLASSPATH=${weblogic_home_dir}/server/lib/weblogic.jar", "JAVA_HOME=${jdk_home_dir}"],
    unless      => "ls -l ${user_config_dir}/${os_user}-${domain_name}-WebLogicConfig.properties",
    path        => $exec_path,
    user        => $os_user,
    group       => $os_group,
    logoutput   => $log_output,
    require     => File["${download_dir}/${title}storeUserConfig.py"],
  }

}

