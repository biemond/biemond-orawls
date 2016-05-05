newproperty(:port) do
  include EasyType

  desc 'The port of the virtual target'

  to_translate_to_resource do | raw_resource|
    raw_resource['port']
  end

end
