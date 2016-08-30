newparam(:template_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The JMS Template name'

end
