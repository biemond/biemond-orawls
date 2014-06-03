newproperty(:deploymenttype) do
  include EasyType

  desc "The deployment type"

  to_translate_to_resource do | raw_resource|
    raw_resource['deploymenttype']
  end

end

