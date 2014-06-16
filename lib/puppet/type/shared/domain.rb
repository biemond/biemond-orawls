newparam(:domain) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc "Domain name"

  defaultto 'default'

  to_translate_to_resource do | raw_resource|
    raw_resource['domain']
  end

end
