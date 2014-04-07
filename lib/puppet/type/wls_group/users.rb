newproperty(:users) do
  include EasyType

  desc "The users of a group"
  
  to_translate_to_resource do | raw_resource|
    raw_resource['users']
  end

end
