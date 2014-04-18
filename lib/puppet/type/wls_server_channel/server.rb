newparam(:server) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "The server name"

  to_translate_to_resource do | raw_resource|
    raw_resource['server']
  end

end
