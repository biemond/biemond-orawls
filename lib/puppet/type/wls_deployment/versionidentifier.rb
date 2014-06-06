newproperty(:versionidentifier) do
  include EasyType

  desc "The version identifier"

  to_translate_to_resource do | raw_resource|
    raw_resource['versionidentifier']
  end

end

