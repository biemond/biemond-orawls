newproperty(:frontendhost) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The frontendhost of this cluster'

  to_translate_to_resource do | raw_resource|
    raw_resource['frontendhost']
  end

end
