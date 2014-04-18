newproperty(:unicastbroadcastchannel) do
  include EasyType
  include EasyType::Validators::Name

  desc "The unicast broadcast channel of this cluster"

  to_translate_to_resource do | raw_resource|
    raw_resource['unicastbroadcastchannel']
  end

end

