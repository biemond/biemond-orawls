newparam(:imported_destination_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "SAF imported destination name"

end
