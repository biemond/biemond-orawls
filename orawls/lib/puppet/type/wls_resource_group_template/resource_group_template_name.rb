newparam(:resource_group_template_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The resource group template name'

end
