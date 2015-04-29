newparam(:coherence_server_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The coherence server name'

end
