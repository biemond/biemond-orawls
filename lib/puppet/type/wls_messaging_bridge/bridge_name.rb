newparam(:bridge_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The bridge name'

end
