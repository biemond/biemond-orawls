newproperty(:bytesmaximum) do
  include EasyType

  desc "Quota Bytes Maximum"

  to_translate_to_resource do | raw_resource|
    raw_resource['bytesmaximum']
  end

end
