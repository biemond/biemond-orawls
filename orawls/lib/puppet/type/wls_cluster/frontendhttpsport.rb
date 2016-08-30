newproperty(:frontendhttpsport) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The frontendhttpsport of this cluster'

  to_translate_to_resource do | raw_resource|
    raw_resource['frontendhttpsport']
  end

end
