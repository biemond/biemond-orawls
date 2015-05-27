newproperty(:redeliverydelay) do
  include EasyType
  include EasyType::Validators::Integer

  desc 'redelivery delay'

  to_translate_to_resource do | raw_resource|
    raw_resource['redeliverydelay']
  end

end
