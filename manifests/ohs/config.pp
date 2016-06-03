define orawls::ohs::config (
  $server_name,
  $domain_path,
  $owner,
  $group,
  $locations = undef,
  $rewrites  = undef,
) {

  $mod_wl_ohs_config_file = "${domain_path}/config/fmwconfig/components/OHS/instances/${server_name}/mod_wl_ohs.conf"
  $mod_wl_ohs_dir = "${domain_path}/config/fmwconfig/components/OHS/instances/${server_name}/mod_wl_ohs.d"

  if (!defined(File[$mod_wl_ohs_dir])) {
    file { $mod_wl_ohs_dir:
      ensure  => directory,
      owner   => $owner,
      group   => $group,
      mode    => '0640',
    }
  }

  if (!defined(File[$mod_wl_ohs_config_file])) {
    file { $mod_wl_ohs_config_file:
      ensure  => present,
      source => 'puppet:///modules/orawls/mod_wl_ohs.conf',
      owner   => $owner,
      group   => $group,
      mode    => '0640',
    }
  }

  file { "${mod_wl_ohs_dir}/${title}.conf":
    ensure  => present,
    content => template('orawls/ohs/mod_wl_ohs_config.conf.erb'),
    owner   => $owner,
    group   => $group,
    mode    => '0640',
    require => File[$mod_wl_ohs_dir],
  }
}