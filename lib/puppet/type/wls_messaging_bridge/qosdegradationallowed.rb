newproperty(:qosdegradationallowed) do
  include EasyType

  desc 'Specifies if this messaging bridge instance allows the degradation of its QOS (quality of service) when the configured QOS is not available.'
  newvalues(1, 0)
  defaultto '0'

  to_translate_to_resource do | raw_resource|
    raw_resource['qosdegradationallowed']
  end
end