newproperty(:localjndiname) do
  include EasyType

  desc 'The local jndi name'

  to_translate_to_resource do | raw_resource|
    raw_resource['localjndiname']
  end

end
