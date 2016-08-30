newproperty(:reconnectpolicy) do
  include EasyType

  desc 'Reconnect policy'

  to_translate_to_resource do | raw_resource|
    raw_resource['reconnectpolicy']
  end

end
