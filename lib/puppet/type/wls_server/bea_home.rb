newproperty(:bea_home) do
  include EasyType

  desc 'The BEA home directory (path on the machine running Node Manager) to use when starting this server. '

  to_translate_to_resource do | raw_resource|
    return '' if raw_resource['bea_home'].nil?
    raw_resource['bea_home']
  end

end
