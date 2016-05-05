newparam(:resource_group_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The resource group name'

end
