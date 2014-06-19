newproperty(:jpa_default_provider) do
  include EasyType

  desc "The JPA default provider java class"

  to_translate_to_resource do | raw_resource|
    raw_resource['jpa_default_provider']
  end

end