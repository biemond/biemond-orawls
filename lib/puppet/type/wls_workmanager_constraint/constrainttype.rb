newproperty(:constrainttype) do
  include EasyType

  desc "Workmanager constraint name"

  to_translate_to_resource do | raw_resource|
    raw_resource['constrainttype']
  end

end
