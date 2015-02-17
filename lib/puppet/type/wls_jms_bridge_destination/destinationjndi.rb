newproperty(:destinationjndi) do
  include EasyType

  isnamevar

  desc 'The destination JNDI name for this JMS bridge destination.'
  
  to_translate_to_resource do |raw_resource|
    raw_resource['destinationjndi']
  end

end