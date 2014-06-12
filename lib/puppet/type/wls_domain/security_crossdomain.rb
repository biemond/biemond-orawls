newproperty(:security_crossdomain) do
  include EasyType

  desc "The cross domain enabled"

  to_translate_to_resource do | raw_resource|
    raw_resource['security_crossdomain']
  end

end