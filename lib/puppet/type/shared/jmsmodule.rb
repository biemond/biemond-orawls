newparam(:jmsmodule) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The JMS module name'

  to_translate_to_resource do | raw_resource|
    raw_resource['jmsmodule']
  end

end
