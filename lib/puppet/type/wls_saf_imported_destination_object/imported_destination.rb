newparam(:imported_destination) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  to_translate_to_resource do | raw_resource|
    raw_resource['imported_destination']
  end


  desc "SAF imported destination name"

end
