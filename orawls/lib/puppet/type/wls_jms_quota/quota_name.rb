newparam(:quota_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The quota name'

end
