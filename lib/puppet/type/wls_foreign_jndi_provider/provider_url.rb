newproperty(:provider_url) do
  include EasyType

  desc 'The URL to use for the Foreign JNDI provider'

  to_translate_to_resource do | raw_resource|
    raw_resource['provider_url']
  end

end
