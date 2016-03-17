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
  $adminserver_address = 'localhost',
  $adminserver_port    = 7001,
  $weblogic_user       = 'weblogic',
  $weblogic_password   = undef,
  $userConfigFile      = undef,
  $userKeyFile         = undef,
  $server              = 'AdminServer',
  $log_dir             = undef, # /data/logs
)
{
  $version              = $::orawls::weblogic::version
  $middleware_home_dir  = $::orawls::weblogic::middleware_home_dir
  $weblogic_home_dir    = $::orawls::weblogic::weblogic_home_dir
  $wls_domains_dir      = $::orawls::weblogic::wls_domains_dir
  $wls_apps_dir         = $::orawls::weblogic::wls_apps_dir
  $jdk_home_dir         = $::orawls::weblogic::jdk_home_dir
  $os_user              = $::orawls::weblogic::os_user
  $os_group             = $::orawls::weblogic::os_group
  $download_dir         = $::orawls::weblogic::download_dir
  $log_output           = $::orawls::weblogic::log_output
  $oracle_base_home_dir = $::orawls::weblogic::oracle_base_home_dir
  $source               = $::orawls::weblogic::source
  $temp_directory       = $::orawls::weblogic::temp_directory

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

