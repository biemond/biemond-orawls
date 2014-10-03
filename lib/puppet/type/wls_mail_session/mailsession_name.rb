newparam(:mailsession_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "The mail session name"

end
