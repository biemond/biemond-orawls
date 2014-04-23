newproperty(:defaulttargeting) do
  include EasyType

  desc "default targeting enabled"
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['defaulttargeting']
  end

end
