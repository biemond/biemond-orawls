newproperty(:custom_identity_alias) do
  include EasyType

  desc "The custom identity alias"

  to_translate_to_resource do | raw_resource|
    raw_resource['custom_identity_alias']
  end

end