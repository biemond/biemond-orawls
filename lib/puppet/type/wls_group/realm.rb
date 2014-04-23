newproperty(:realm) do
  include EasyType

  desc "The security realm of the domain"
  
  to_translate_to_resource do | raw_resource|
    raw_resource['realm']
  end

end
