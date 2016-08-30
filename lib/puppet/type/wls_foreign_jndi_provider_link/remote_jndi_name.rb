newproperty(:remote_jndi_name) do
  include EasyType

  desc 'The remote jndi name to use for the Foreign JNDI provider link'

  to_translate_to_resource do | raw_resource|
    raw_resource['remote_jndi_name']
  end

end
