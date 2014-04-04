newparam(:object_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "SAF imported destination Object name"

end
