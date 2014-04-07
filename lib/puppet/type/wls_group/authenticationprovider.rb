newproperty(:authenticationprovider) do
  include EasyType

  desc "The security authentication providers of the domain"
  
  to_translate_to_resource do | raw_resource|
    raw_resource['authenticationprovider']
  end

end
