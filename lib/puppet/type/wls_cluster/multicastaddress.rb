newproperty(:multicastaddress) do
  include EasyType
  include EasyType::Validators::Name

  desc "The multi cast address of this cluster"

  to_translate_to_resource do | raw_resource|
    raw_resource['multicastaddress']
  end

end

