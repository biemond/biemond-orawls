newparam(:name) do
  include EasyType
  include EasyType::Validators::Name

  desc "The CF name"

  isnamevar

  to_translate_to_resource do | raw_resource|
  	raw_resource['name'].split(':')[1]
  end

end
