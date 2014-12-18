newparam(:foreign_server) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  to_translate_to_resource do | raw_resource|
    raw_resource['foreign_server']
  end

  desc 'Foreign server name'

end

autorequire(:wls_foreign_server) { "#{jmsmodule}:#{foreign_server}" }
