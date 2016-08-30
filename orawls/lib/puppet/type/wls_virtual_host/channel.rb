newproperty(:channel) do
  include EasyType

  desc 'Server channel name'

  to_translate_to_resource do | raw_resource|
    raw_resource['channelname']
  end

end
