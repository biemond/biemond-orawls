newproperty(:maximum_server_count) do
  include EasyType
  include EasyType::Validators::Name

  desc "The maximum server count of this cluster"

  to_translate_to_resource do | raw_resource|
    raw_resource['maximum_server_count']
  end

end
