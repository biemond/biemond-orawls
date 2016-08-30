newparam(:virtual_host_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The virtual host name'

end
