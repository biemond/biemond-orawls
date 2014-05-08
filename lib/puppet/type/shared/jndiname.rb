newproperty(:jndiname) do
  include EasyType

  desc "The jndi name"

  to_translate_to_resource do | raw_resource|
    raw_resource['jndiname']
  end

end