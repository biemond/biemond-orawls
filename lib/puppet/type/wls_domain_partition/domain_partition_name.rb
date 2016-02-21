newparam(:domain_partition_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The domain partition group name'

end
