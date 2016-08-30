newproperty(:store_enabled) do
  include EasyType

  desc 'Specifies whether message persistence is supported for this JMS server. only for wls 10.3'

  newvalues('0', '1')

  to_translate_to_resource do | raw_resource|
    raw_resource['store_enabled']
  end

end
