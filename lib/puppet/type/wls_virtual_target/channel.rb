newproperty(:channel) do
  include EasyType

  desc 'virtual target channel name'

  to_translate_to_resource do | raw_resource|
    raw_resource['channelname']
  end

  defaultto 'PartitionChannel'

end
