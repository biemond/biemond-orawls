newproperty(:jndinames) do
  include EasyType

  desc "The datasource jndi names"

  to_translate_to_resource do | raw_resource|
    raw_resource['jndinames']
  end

end