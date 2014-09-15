newproperty(:defaulttargeting) do
  include EasyType

  desc 'default targeting enabled'
  newvalues(1, 0)
  defaultto 1

  to_translate_to_resource do | raw_resource|
    raw_resource['defaulttargeting']
  end

end
