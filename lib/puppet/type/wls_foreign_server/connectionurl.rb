newproperty(:connectionurl) do
  include EasyType

  desc "The connectionurl"

  to_translate_to_resource do | raw_resource|
    raw_resource['connectionurl']
  end

end