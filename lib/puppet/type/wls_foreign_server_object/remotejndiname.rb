newproperty(:remotejndiname) do
  include EasyType

  desc "The Remote JNDI of the Foreign server object "

  to_translate_to_resource do | raw_resource|
    raw_resource['remotejndiname']
  end

end
