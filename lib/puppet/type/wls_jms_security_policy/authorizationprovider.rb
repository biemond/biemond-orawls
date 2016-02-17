newparam(:authorizationprovider) do
  include EasyType

  desc 'The security authorization providers of the domain'

  defaultto 'XACMLAuthorizer'

  to_translate_to_resource do | raw_resource |
    raw_resource['authorizationprovider']
  end

end
