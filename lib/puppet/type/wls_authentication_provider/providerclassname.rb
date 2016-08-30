newparam(:providerclassname) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The provider classname'

  to_translate_to_resource do | raw_resource|
    raw_resource['providerclassname']
  end

end
