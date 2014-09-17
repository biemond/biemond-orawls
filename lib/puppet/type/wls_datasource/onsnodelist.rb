newproperty(:onsnodelist) do
  include EasyType

  desc "A comma-separate list of ONS daemon listen addresses and ports to which connect to for receiving ONS-based FAN events"

  to_translate_to_resource do | raw_resource|
    raw_resource['onsnodelist']
  end

end