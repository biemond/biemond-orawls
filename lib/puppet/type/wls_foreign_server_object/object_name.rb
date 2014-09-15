newparam(:object_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'Foreign Server Object name'

end
