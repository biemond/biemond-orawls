newproperty(:extrapropertiesvalues) do
  include EasyType

  desc "The foreign server property values"

  to_translate_to_resource do | raw_resource|
    raw_resource['extrapropertiesvalues']
  end

end