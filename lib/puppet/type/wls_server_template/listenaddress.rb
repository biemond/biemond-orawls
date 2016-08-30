newproperty(:listenaddress) do
  include EasyType

  desc 'The listenaddress of the server'

  to_translate_to_resource do | raw_resource|
    raw_resource['listenaddress']
  end

end
