newparam(:user_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The user name'

end
