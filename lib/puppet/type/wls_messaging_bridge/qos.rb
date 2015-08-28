newproperty(:qos) do
  include EasyType

  desc 'The QOS (quality of service) for this messaging bridge instance.'

  newvalues('Exactly-once', 'Atmost-once', 'Duplicate-okay')
  defaultto 'Exactly-once'

  to_translate_to_resource do | raw_resource|
    raw_resource['qos']
  end

end
