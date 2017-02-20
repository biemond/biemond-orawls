#
# ohs::forwarder define
#
# Add a webtier forwarder entry
#
# @example Declaring the class
#  orawls::ohs::forwarder { '/console':
#    servers     => ['192.168.1.1:7000'],
#    os_user     => 'oracle',
#    os_group    => 'oracle',
#    domain_dir  => '/opt/test/wls/domains/domain1',
#    require     => Orawls::Control["start ohs ${domain_name}"],
#    notify      => Wls_ohsserver["reload ohs ${domain_name}"],
#  }
#
#  orawls::ohs::forwarder { 'apps':
#    servers     => ['192.168.1.2:7000', '192.168.1.3:7000', '192.168.1.4:7002'],
#    os_user     => 'oracle',
#    os_group    => 'oracle',
#    location    => '^(?!(/console|/OracleHTTPServer12c_files|/index.html))',
#    domain_dir  => '/opt/test/wls/domains/domain1',
#    require     => Orawls::Control["start ohs ${domain_name}"],
#    notify      => Wls_ohsserver["reload ohs ${domain_name}"],
#  }
# 
# notify option is needed to OHS restart and load changes.
# require is needed because without it, notify option may attempt to reload server before it's running.
#
# 
# @param os_user the user name with oracle as default, will be default derived from the weblogic class
# @param os_group the group name with dba as default, will be default derived from the weblogic class
#
define orawls::ohs::forwarder (
  Enum['present','absent'] $ensure  = 'present',
  String $os_user                   = $::orawls::weblogic::os_user,
  String $os_group                  = $::orawls::weblogic::os_group,
  Array $servers                    = undef,
  String $domain_dir                = undef,
)
{
  $size = size($servers)
  $servers_string = join($servers, ',')

  # TODO: create and use function sanitize_string (fmw.pp, duplicated code)
  $convert_spaces_to_underscores = regsubst($title,'\s','_','G')
  $sanitised_title = regsubst($convert_spaces_to_underscores,'[^a-zA-Z0-9_-]','','G')

  # puppet epp render forwarder.conf.epp --values "{location => 'aaa' , size => 1, servers => ['192.168.1.1:7000'] }"
  # puppet epp render forwarder.conf.epp --values "{location => 'aaa' , size => 3, servers => ['192.168.1.2:7000', '192.168.1.3:7000', '192.168.1.4:7002'], servers_string => '192.168.1.2:7000,192.168.1.3:7000,192.168.1.4:7002' }"

  file { "${domain_dir}/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/${sanitised_title}.conf":
    ensure  => $ensure,
    content => epp('orawls/ohs/forwarder.conf.epp', {
                    'location'       => $title,
                    'size'           => $size,
                    'servers'        => $servers,
                    'servers_string' => $servers_string}),
    owner   => $os_user,
    group   => $os_user,
    mode    => '0640',
  }
}
