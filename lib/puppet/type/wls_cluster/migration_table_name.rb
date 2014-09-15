newproperty(:migration_table_name) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The migration table name of this cluster when database leasing is used'

  defaultto 'ACTIVE'

  to_translate_to_resource do | raw_resource|
    raw_resource['migration_table_name']
  end

end
