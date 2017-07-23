newproperty(:logindelayseconds) do
  include EasyType

  desc 'Login delay seconds'

  to_translate_to_resource do | raw_resource|
    raw_resource['logindelayseconds']
  end

end