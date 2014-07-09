# == Define: orawls::fmwlogdir
#
# generic fmwlogdir wlst script, runs the WLST command from the oracle common home
# Moves the fmw log files like  AdminServer-diagnostic.log or AdminServer-owsm.log
# to a different location outside your domain
#
# pass on the weblogic username or password
# or provide userConfigFile and userKeyFile file locations
#
#
#
define orawls::fmwlogdir (
  $middleware_home_dir        = hiera('wls_middleware_home_dir'), # /opt/oracle/middleware11gR1
  $oracle_home_dir            = undef,                            # /opt/oracle/middleware11gR1/Oracle_OSB
  $adminserver_address        = hiera('domain_adminserver_address', "localhost"),
  $adminserver_port           = hiera('domain_adminserver_port'   , 7001),
  $weblogic_user              = hiera('wls_weblogic_user'         , "weblogic"),
  $weblogic_password          = hiera('domain_wls_password'       , undef),
  $userConfigFile             = hiera('domain_user_config_file'   , undef),
  $userKeyFile                = hiera('domain_user_key_file'      , undef),
  $os_user                    = hiera('wls_os_user'), # oracle
  $os_group                   = hiera('wls_os_group'), # dba
  $download_dir               = hiera('wls_download_dir'), # /data/install
  $log_output                 = false, # true|false
  $server                     = 'AdminServer',
  $log_dir                    = hiera('wls_log_dir'               , undef), # /data/logs
) 
{
  $execPath = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

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
    content => template("orawls/wlst/changeFMWLogFolder.py.erb"),
    replace => true,
    mode    => '0555',
    owner   => $os_user,
    group   => $os_group,
    backup  => false,
  }

  if $oracle_home_dir == undef {
    $l_cmd = "${middleware_home_dir}/oracle_common/common/bin/wlst.sh ${download_dir}/${title}changeFMWLogFolder.py ${weblogic_password}"
  } else {
    $l_cmd = "${oracle_home_dir}/common/bin/wlst.sh ${download_dir}/${title}changeFMWLogFolder.py ${weblogic_password}"
  }
  
  exec { "execwlst ${title}changeFMWLogFolder.py":
    command   => $l_cmd,
    unless    => "ls -l ${log_dir}/${server}-diagnostic.log",
    require   => File["${download_dir}/${title}changeFMWLogFolder.py"],
    path      => $execPath,
    user      => $os_user,
    group     => $os_group,
    logoutput => $log_output,
  }
}

