newproperty(:servers) do
  include EasyType
  include EasyType::Validators::Name

  desc "The nodes which are part of this cluster"

  to_translate_to_resource do | raw_resource|
    raw_resource['servers']
  end

end
