newproperty(:listenport) do
  include EasyType

  desc 'The channel listenport of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['listenport']
  end

end
