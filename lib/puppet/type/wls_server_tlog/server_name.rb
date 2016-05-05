newparam(:server_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The server name'

end
