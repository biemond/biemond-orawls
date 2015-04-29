newproperty(:unicastport) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The unicast port of this cluster'

  to_translate_to_resource do | raw_resource|
    raw_resource['unicastport']
  end

end
