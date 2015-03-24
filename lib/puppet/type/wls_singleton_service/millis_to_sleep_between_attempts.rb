newproperty(:millis_to_sleep_between_attempts) do
    include EasyType

    desc 'The amount of milliseconds to wait between attempts to migrate this singleton service'

    defaultto 300000

    to_translate_to_resource do | raw_resource|
        raw_resource['millis_to_sleep_between_attempts']
    end
end
