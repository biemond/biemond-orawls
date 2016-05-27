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
  $middleware_home_dir        = $::orawls::weblogic::middleware_home_dir, # /opt/oracle/middleware11gR1
  $adminserver_address        = 'localhost',
  $adminserver_port           = 7001,
  $weblogic_user              = 'weblogic',
  $weblogic_password          = undef,
  $userConfigFile             = undef,
  $userKeyFile                = undef,
  $os_user                    = $::orawls::weblogic::os_user, # oracle
  $os_group                   = $::orawls::weblogic::os_group, # dba
  $download_dir               = $::orawls::weblogic::download_dir, # /data/install
  $log_output                 = $::orawls::weblogic::log_output, # true|false
  $server                     = 'AdminServer',
  $log_dir                    = undef, # /data/logs
)
{
  $execPath = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'

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
    content => template('orawls/wlst/changeFMWLogFolder.py.erb'),
    replace => true,
    mode    => '0555',
    owner   => $os_user,
    group   => $os_group,
    backup  => false,
  }

  exec { "execwlst ${title}changeFMWLogFolder.py":
    command   => "${middleware_home_dir}/oracle_common/common/bin/wlst.sh ${download_dir}/${title}changeFMWLogFolder.py ${weblogic_password}",
    unless    => "ls -l ${log_dir}/${server}-diagnostic.log",
    require   => File["${download_dir}/${title}changeFMWLogFolder.py"],
    path      => $execPath,
    user      => $os_user,
    group     => $os_group,
    logoutput => $log_output,
  }
}
