newproperty(:store_enabled) do
  include EasyType

  desc 'Specifies whether message persistence is supported for this JMS server.'

  to_translate_to_resource do | raw_resource|
    raw_resource['store_enabled']
  end


end