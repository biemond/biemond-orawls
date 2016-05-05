newproperty(:useservercerts) do
  include EasyType

  desc 'Use Server Certs option Enabled on the server'
  newvalues('1', '0')

  to_translate_to_resource do | raw_resource|
    raw_resource['useservercerts']
  end

end
