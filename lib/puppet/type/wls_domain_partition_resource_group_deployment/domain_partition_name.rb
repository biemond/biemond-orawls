newparam(:domain_partition_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The domain partition group name'

  to_translate_to_resource do | raw_resource|
    raw_resource['domain_partition_name']
  end

end

autorequire(:wls_domain_partition) { "#{domain}/#{domain_partition_name}" }
