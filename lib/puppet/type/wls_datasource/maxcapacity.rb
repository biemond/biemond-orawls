newproperty(:maxcapacity) do
  include EasyType

  desc "The max capacity of the datasource"

  defaultto '15'

  to_translate_to_resource do | raw_resource|
    raw_resource['maxcapacity']
  end

end