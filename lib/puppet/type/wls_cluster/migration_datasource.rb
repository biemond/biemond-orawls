newproperty(:migration_datasource) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The migration datasource of this cluster when database leasing is used'

  to_translate_to_resource do | raw_resource|
    raw_resource['migration_datasource']
  end

end
