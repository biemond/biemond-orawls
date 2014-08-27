newproperty(:server_name_prefix) do
  include EasyType
  include EasyType::Validators::Name

  desc "The server name prefix of this dynamic cluster"

  to_translate_to_resource do | raw_resource|
    raw_resource['server_name_prefix']
  end

end
