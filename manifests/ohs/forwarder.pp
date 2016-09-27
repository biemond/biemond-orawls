#
# Usage:
#  orawls::ohs::forwarder { '/console':
#    servers     => ['192.168.1.1:7000'],
#    owner       => 'oracle',
#    group       => 'oracle',
#    domain_path => '/opt/test/wls/domains/domain1',
#    require     => Orawls::Control["start ohs ${domain_name}"],
#    notify      => Wls_ohsserver["reload ohs ${domain_name}"],
#  }
#
#  orawls::ohs::forwarder { 'apps':
#    servers     => ['192.168.1.2', '192.168.1.3', '192.168.1.4:7002'],
#    owner       => 'oracle',
#    group       => 'oracle',
#    location    => '^(?!(/console|/OracleHTTPServer12c_files|/index.html))',
#    domain_path => '/opt/test/wls/domains/domain1',
#    require     => Orawls::Control["start ohs ${domain_name}"],
#    notify      => Wls_ohsserver["reload ohs ${domain_name}"],
#  }
# 
# notify option is needed to OHS restart and load changes.
# require is needed because without it, notify option may attempt to reload server before it's running.
#
define orawls::ohs::forwarder (
  $owner,
  $group,
  $servers,
  $domain_path,
  $default_port = 7001,
  $ensure       = 'present',
  $location     = $title,
) {
  if empty($servers) {
    fail("servers can't be empty")
  }

  # TODO: create and use function sanitize_string (fmw.pp, duplicated code)
  $convert_spaces_to_underscores = regsubst($title,'\s','_','G')
  $sanitised_title = regsubst($convert_spaces_to_underscores,'[^a-zA-Z0-9_-]','','G')

  file { "${domain_path}/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/${sanitised_title}.conf":
    ensure  => $ensure,
    content => template('orawls/ohs/forwarder.conf.erb'),
    owner   => $owner,
    group   => $group,
    mode    => '0640',
  }
}
