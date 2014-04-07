newparam(:foreign_server_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "Foreign Server name"

end
