newproperty(:number_of_restart_attempts) do
  include EasyType

  desc 'number_of_restart_attempts'

  defaultto 2

  to_translate_to_resource do | raw_resource|
    raw_resource['number_of_restart_attempts']
  end
end
