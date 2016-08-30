newparam(:key_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The key name'

end
