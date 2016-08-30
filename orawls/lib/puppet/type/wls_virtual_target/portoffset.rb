newproperty(:portoffset) do
  include EasyType

  desc 'The port offset of the virtual target'

  to_translate_to_resource do | raw_resource|
    raw_resource['portoffset']
  end

end
