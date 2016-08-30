newproperty(:trust_keystore_passphrase) do
  include EasyType

  desc 'The trust keystore passphrase'

  to_translate_to_resource do |raw_resource|
    raw_resource[self.name]
  end
end
