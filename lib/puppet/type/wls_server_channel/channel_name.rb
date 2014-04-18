newparam(:channel_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "Server channel name"

end
