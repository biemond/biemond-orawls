newproperty(:persistentstoretype) do
  include EasyType

  desc "The persistentstore type"

  to_translate_to_resource do | raw_resource|
    raw_resource['persistentstoretype']
  end

end