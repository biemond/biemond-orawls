newproperty(:additional_migration_attempts) do
    include EasyType

    desc 'blabla'

    defaultto 2

    to_translate_to_resource do | raw_resource|
        raw_resource['additional_migration_attempts']
    end
end
