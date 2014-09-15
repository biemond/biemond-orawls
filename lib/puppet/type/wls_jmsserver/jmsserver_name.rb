newparam(:jmsserver_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The jmsserver_name name'

end
