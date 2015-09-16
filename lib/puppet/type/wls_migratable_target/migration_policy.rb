newproperty(:migration_policy) do
  include EasyType

  desc 'The migration policy for migratable target'

  newvalues(:'manual', :'exactly-once', :'failure-recovery')

  defaultto 'exactly-once'

  to_translate_to_resource do | raw_resource |
    raw_resource['migration_policy']
  end

end
