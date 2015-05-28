newproperty(:defaultredeliverydelay) do
  include EasyType

  desc 'The default redelivery delay'

  to_translate_to_resource do | raw_resource|
    raw_resource['defaultredeliverydelay']
  end

end
