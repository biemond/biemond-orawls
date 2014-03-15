newproperty(:extraproperties) do
  include EasyType

  desc "The extra datasource properties"

  to_translate_to_resource do | raw_resource|
    raw_resource['extraproperties']
  end

end