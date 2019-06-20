newproperty(:harvest_trigger_count) do
  include EasyType

  desc 'The statement cache size of the datasource'

  to_translate_to_resource do | raw_resource|
    raw_resource['harvest_trigger_count']
  end

end
