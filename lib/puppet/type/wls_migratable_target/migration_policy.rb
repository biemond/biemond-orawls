newproperty(:migration_policy) do
    include EasyType
    
    desc 'The migration policy for migratable target'
    
    to_translate_to_resource do | raw_resource|
        raw_resource['migration_policy']
    end
end