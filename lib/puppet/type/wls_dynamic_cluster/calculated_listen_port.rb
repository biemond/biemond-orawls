newproperty(:calculated_listen_port) do
  include EasyType
  include EasyType::Validators::Name

  desc 'Set managed server ports is auto calculated'

  to_translate_to_resource do | raw_resource|
    raw_resource['calculated_listen_port']
  end
end
