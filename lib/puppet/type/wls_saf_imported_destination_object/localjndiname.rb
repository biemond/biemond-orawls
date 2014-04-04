newproperty(:localjndiname) do
  include EasyType

  desc "The Local JNDI of the SAF imported destination object "

  to_translate_to_resource do | raw_resource|
    raw_resource['localjndiname']
  end

end
