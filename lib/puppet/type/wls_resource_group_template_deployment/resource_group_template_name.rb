newparam(:resource_group_template_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The resource group template name'

end

autorequire(:wls_resource_group_template) { "#{domain}/#{resource_group_template_name}" }
