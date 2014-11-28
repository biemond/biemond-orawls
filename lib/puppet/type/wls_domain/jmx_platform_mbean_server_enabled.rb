newparam(:jmx_platform_mbean_server_enabled) do
  include EasyType

  desc 'Platform MBean server enabled'

  to_translate_to_resource do | raw_resource|
    raw_resource['jmx_platform_mbean_server_enabled']
  end

end
