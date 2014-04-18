newproperty(:protocol) do
  include EasyType

  desc "The server channel protocol"

  to_translate_to_resource do | raw_resource|
    raw_resource['protocol']
  end

end
