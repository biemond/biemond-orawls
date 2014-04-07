newproperty(:description) do
  include EasyType

  desc "The user description"
  
  to_translate_to_resource do | raw_resource|
    raw_resource['description']
  end

end
