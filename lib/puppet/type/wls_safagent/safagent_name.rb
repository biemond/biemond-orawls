newparam(:safagent_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The SAF agent name'

end
