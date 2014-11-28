newproperty(:jmx_platform_mbean_server_used) do
  include EasyType

  desc 'Platform MBean server used'

  to_translate_to_resource do | raw_resource|
    raw_resource['jmx_platform_mbean_server_used']
  end

end
