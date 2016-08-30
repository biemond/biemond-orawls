newproperty(:redeliverylimit) do
  include EasyType

  desc 'redelivery limit'

  to_translate_to_resource do | raw_resource|
    raw_resource['redeliverylimit']
  end

end
