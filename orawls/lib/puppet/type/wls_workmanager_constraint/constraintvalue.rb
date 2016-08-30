newproperty(:constraintvalue) do
  include EasyType

  desc 'The value of a workmanager constraint'

  to_translate_to_resource do | raw_resource|
    raw_resource['constraintvalue']
  end

end
