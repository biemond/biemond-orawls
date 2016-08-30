newproperty(:trust_keystore_file) do
  include EasyType

  desc 'The trust keystore file'

  to_translate_to_resource do | raw_resource|
    raw_resource['trust_keystore_file']
  end

end
