newproperty(:extraproperties) do
  include EasyType

  desc "The extra foreign server properties"

  to_translate_to_resource do | raw_resource|
    raw_resource['extraproperties']
  end

end