newparam(:name) do
  include EasyType
  include EasyType::Validators::Name

  desc "The foreign server object name"

  isnamevar

  to_translate_to_resource do | raw_resource|
    raw_resource['name']
  end

end
