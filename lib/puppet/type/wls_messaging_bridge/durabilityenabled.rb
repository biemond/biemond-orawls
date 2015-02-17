newproperty(:durabilityenabled) do
  include EasyType

  desc 'Specifies whether or not the messaging bridge allows durable messages'
    newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['durabilityenabled']
  end
end