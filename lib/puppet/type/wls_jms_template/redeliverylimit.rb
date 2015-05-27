newproperty(:redeliverylimit) do
  include EasyType
  include EasyType::Validators::Integer

  desc 'redelivery limit'

  to_translate_to_resource do | raw_resource|
    raw_resource['redeliverylimit']
  end

end
