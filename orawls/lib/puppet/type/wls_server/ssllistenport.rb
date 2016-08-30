newproperty(:ssllistenport) do
  include EasyType
  desc 'The server ssl port'

  to_translate_to_resource do | raw_resource|
    raw_resource['ssllistenport']
  end

end
