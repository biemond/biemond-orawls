newproperty(:tlog_datasource) do
  include EasyType

  desc 'The tlog datasource name'

  to_translate_to_resource do | raw_resource|
    raw_resource['tlog_datasource']
  end

end
