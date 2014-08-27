newproperty(:server_template_name) do
  include EasyType
  include EasyType::Validators::Name

  desc "The server template name of this cluster"

  to_translate_to_resource do | raw_resource|
    raw_resource['server_template_name']
  end

end
