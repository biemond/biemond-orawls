newproperty(:migration_policy) do
  include EasyType

  desc 'The JDBC persistent store migration policy'

  to_translate_to_resource do | raw_resource |
    raw_resource['migration_policy']
  end

end
