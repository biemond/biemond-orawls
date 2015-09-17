newproperty(:seconds_between_restarts) do
  include EasyType

  desc 'The amount of milliseconds to wait between attempts to migrate this migratable target'

  defaultto 300000

  to_translate_to_resource do | raw_resource|
    raw_resource['seconds_between_restarts']
  end
end
