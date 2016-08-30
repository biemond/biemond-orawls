newproperty(:multicastport) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The multi cast port of this cluster'

  to_translate_to_resource do | raw_resource|
    raw_resource['multicastport']
  end

end
