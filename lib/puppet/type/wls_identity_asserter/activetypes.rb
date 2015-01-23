newproperty(:activetypes) do
  include EasyType

  desc ':: seperated list of active types'

  to_translate_to_resource do | raw_resource|
    raw_resource['activetypes']
  end

end
