newproperty(:tlog_datasource_prefix) do
  include EasyType

  desc 'The datasource prefix name for jdbc tlog'

  to_translate_to_resource do | raw_resource|
    raw_resource['tlog_datasource_prefix']
  end

end
