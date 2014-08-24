newproperty(:unicastaddress) do
  include EasyType
  include EasyType::Validators::Name

  desc "The unicast address of this cluster"

  to_translate_to_resource do | raw_resource|
    raw_resource['unicastaddress']
  end

end

