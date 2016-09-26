#
# Usage:
# TODO
# 
define orawls::ohs::forwarder (
  $owner,
  $group,
  $servers,
  $ohs_config_dir,
  $ensure = 'present',
  $location = $title,
) {
  # TODO: create and use function sanitize_string (fmw.pp, duplicated code)
  $convert_spaces_to_underscores = regsubst($title,'\s','_','G')
  $sanitised_title = regsubst($convert_spaces_to_underscores,'[^a-zA-Z0-9_-]','','G')

  file { "${ohs_config_dir}/mod_wl_ohs.d/${sanitised_title}.conf":
    ensure  => $ensure,
    content => template('orawls/ohs/forwarder.conf.erb'),
    owner   => $owner,
    group   => $group,
    mode    => '0640',
  }
}
