newparam(:bridge_destination_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The bridge destination name'

end
