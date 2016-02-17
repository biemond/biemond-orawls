newproperty(:uriprefix) do
  include EasyType

  desc 'The uri prefix of the virtual target'

  to_translate_to_resource do | raw_resource|
    raw_resource['uriprefix']
  end

  defaultto '/'

end
