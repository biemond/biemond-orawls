newparam(:error_handler_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "SAF error handler name"

end
