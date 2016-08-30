newproperty(:local_jndi_name) do
  include EasyType

  desc 'The local jndi name to use for the Foreign JNDI provider link'

  to_translate_to_resource do | raw_resource|
    raw_resource['local_jndi_name']
  end

end
