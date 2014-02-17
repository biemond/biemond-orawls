newproperty(:persistentstore) do
  include EasyType

  desc "The persistentstore name"

  to_translate_to_resource do | raw_resource|
    raw_resource['persistentstore']
  end

end