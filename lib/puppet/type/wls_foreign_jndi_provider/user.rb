newproperty(:user) do
  include EasyType

  desc 'The user to use for the Foreign JNDI provider'

  to_translate_to_resource do | raw_resource|
    raw_resource['user']
  end

end
