newproperty(:property_name) do
  include EasyType

  desc 'The property'

  to_translate_to_resource do | raw_resource|
    raw_resource['property_name']
  end

end
