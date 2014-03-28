newparam(:connection_factory_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "The Connection Factory name"

end
