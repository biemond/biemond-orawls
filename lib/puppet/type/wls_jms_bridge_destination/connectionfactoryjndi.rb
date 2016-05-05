newproperty(:connectionfactoryjndi) do
  include EasyType

  isnamevar

  desc "The connection factory's JNDI name for this JMS bridge destination."

  to_translate_to_resource do |raw_resource|
    raw_resource['connectionfactoryjndi']
  end

end
