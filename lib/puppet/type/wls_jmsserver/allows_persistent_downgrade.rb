newproperty(:allows_persistent_downgrade) do
  include EasyType

  desc 'Specifies whether JMS clients will get an exception when sending persistent messages to a destination targeted to a JMS server that does not have a persistent store configured.'

  to_translate_to_resource do | raw_resource|
    raw_resource['allows_persistent_downgrade']
  end

end
