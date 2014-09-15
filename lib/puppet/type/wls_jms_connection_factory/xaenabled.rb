newproperty(:xaenabled) do
  include EasyType

  desc 'xa enabled on the cf'
  newvalues(1, 0)
  defaultto 1

  to_translate_to_resource do | raw_resource|
    raw_resource['xaenabled']
  end

end
