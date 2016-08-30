newproperty(:tlog_enabled) do
  include EasyType

  desc 'Enables jdbc tlog functionality'
  newvalues(true,false)

  defaultto 'false'

  to_translate_to_resource do | raw_resource|
    raw_resource['tlog_enabled']
  end

end
