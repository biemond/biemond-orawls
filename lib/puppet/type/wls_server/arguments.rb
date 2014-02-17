newproperty(:arguments) do
  include EasyType

  desc "The server arguments of the server"
  
  to_translate_to_resource do | raw_resource|
    raw_resource['arguments']
  end

end
