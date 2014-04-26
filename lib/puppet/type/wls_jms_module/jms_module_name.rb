newparam(:jms_module_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "The jms module name"

end
