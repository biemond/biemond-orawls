newparam(:resource_group_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The resource group name'

  to_translate_to_resource do | raw_resource|
    raw_resource['resource_group_name']
  end

end

autorequire(:wls_domain_partition_resource_group) { "#{domain}/#{domain_partition_name}:#{resource_group_name}" }
