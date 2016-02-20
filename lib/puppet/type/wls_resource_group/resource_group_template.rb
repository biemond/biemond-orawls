newproperty(:resource_group_template) do
  include EasyType

  desc 'The resource group template name'

  to_translate_to_resource do | raw_resource|
    raw_resource['resource_group_template']
  end

end

autorequire(:wls_resource_group_template) { "#{domain}/#{resource_group_template}" }
