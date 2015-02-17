newproperty(:preservemsgproperty) do
  include EasyType

  desc 'Specifies if message properties are preserved when messages are forwarded by a bridge instance.'
  newvalues(1, 0)
  defaultto '0'

  to_translate_to_resource do | raw_resource|
    raw_resource['preservemsgproperty']
  end
end