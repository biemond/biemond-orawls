newproperty(:key_type) do
  include EasyType

  desc 'The key type'

  to_translate_to_resource do | raw_resource|
    raw_resource['key_type']
  end

end
