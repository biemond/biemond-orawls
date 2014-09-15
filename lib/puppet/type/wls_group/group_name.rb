newparam(:group_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The group name'

end
