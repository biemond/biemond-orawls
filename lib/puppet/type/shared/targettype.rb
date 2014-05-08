newproperty(:targettype) do
  include EasyType

  desc "The type of the target"

  to_translate_to_resource do | raw_resource|
    raw_resource['targettype']
  end

end