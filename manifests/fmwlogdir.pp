#
# fmwlogdir define
#
# Moves the fmw log files like  AdminServer-diagnostic.log or AdminServer-owsm.log to a different location outside your domain
#
# @param middleware_home_dir directory of the Oracle software inside the oracle base directory
# @param adminserver_address the adminserver network name or ip, default = localhost
# @param adminserver_port the adminserver port number, default = 7001
# @param weblogic_user the weblogic administrator username
# @param weblogic_password the weblogic domain password
# @param os_user the user name with oracle as default
# @param os_group the group name with dba as default
# @param log_output show all the output of the the exec actions
# @param download_dir the directory for temporary created files by this class
#
define orawls::fmwlogdir (
  String $middleware_home_dir                             = $::orawls::weblogic::middleware_home_dir,
  Optional[String] $adminserver_address                   = 'localhost',
  Integer $adminserver_port                               = 7001,
  String $weblogic_user                                   = 'weblogic',
  String $weblogic_password                               = undef,
  Optional[String] $userConfigFile                        = undef,
  Optional[String] $userKeyFile                           = undef,
  String $os_user                                         = $::orawls::weblogic::os_user,
  String $os_group                                        = $::orawls::weblogic::os_group,
  String $download_dir                                    = $::orawls::weblogic::download_dir,
  String $log_dir                                         = undef, # /data/logs
  Boolean $log_output                                     = $::orawls::weblogic::log_output,
  String $server                                          = 'AdminServer',
)
{
  $exec_path = lookup('orawls::exec_path')

  # use userConfigStore for the connect
  if $weblogic_password == undef {
    $useStoreConfig = true
  } else {
    # override if config and key files are provided
    if($userConfigFile != undef and $userKeyFile != undef) {
      $useStoreConfig = true
    }
    else {
      $useStoreConfig = false
    }
  }

  # the py script used by the wlst
  file { "${download_dir}/${title}changeFMWLogFolder.py":
    ensure  => present,
    path    => "${download_dir}/${title}changeFMWLogFolder.py",
    content => epp('orawls/wlst/changeFMWLogFolder.py.epp', {
                    'weblogic_user'       => $weblogic_user,
                    'adminserver_address' => $adminserver_address,
                    'adminserver_port'    => $adminserver_port,
                    'userConfigFile'      => $userConfigFile,
                    'userKeyFile'         => $userKeyFile,
                    'useStoreConfig'      => $useStoreConfig,
                    'server'              => $server,
                    'log_dir'             => $log_dir }),
    replace => true,
    mode    => lookup('orawls::permissions_group_restricted'),
    owner   => $os_user,
    group   => $os_group,
    backup  => false,
  }

  exec { "execwlst ${title}changeFMWLogFolder.py":
    command   => "${middleware_home_dir}/oracle_common/common/bin/wlst.sh ${download_dir}/${title}changeFMWLogFolder.py ${weblogic_password}",
    unless    => "ls -l ${log_dir}/${server}-diagnostic.log",
    require   => File["${download_dir}/${title}changeFMWLogFolder.py"],
    path      => $exec_path,
    user      => $os_user,
    group     => $os_group,
    logoutput => $log_output,
  }
}

