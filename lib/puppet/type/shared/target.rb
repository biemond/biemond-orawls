newproperty(:target) do
  include EasyType

  desc "The target name"

  to_translate_to_resource do | raw_resource|
    raw_resource['target']
  end

end