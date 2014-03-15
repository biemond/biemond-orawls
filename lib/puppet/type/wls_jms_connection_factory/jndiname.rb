newproperty(:jndiname) do
  include EasyType

  desc "The jndiname name"

  to_translate_to_resource do | raw_resource|
    raw_resource['jndiname']
  end

end