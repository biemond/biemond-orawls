newproperty(:jndiprefix) do
  include EasyType

  desc 'the SAF JNDI prefix of this SAF imported destination'

  to_translate_to_resource do | raw_resource|
    raw_resource['jndiprefix']
  end

end
