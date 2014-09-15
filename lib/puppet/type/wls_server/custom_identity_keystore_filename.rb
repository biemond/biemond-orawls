newproperty(:custom_identity_keystore_filename) do
  include EasyType

  desc 'The custom identity keystore filename'

  to_translate_to_resource do | raw_resource|
    raw_resource['custom_identity_keystore_filename']
  end

end
