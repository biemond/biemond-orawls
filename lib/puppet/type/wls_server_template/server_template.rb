newparam(:server_template) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The server template name'

end
