newproperty(:ssllistenport) do
  include EasyType
  desc 'The server ssl port'
  defaultto '7002'

  to_translate_to_resource do | raw_resource|
    raw_resource['ssllistenport']
  end

end
