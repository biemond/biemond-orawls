newproperty(:mincapacity) do
  include EasyType

  desc 'The min capacity of the datasource'

  defaultto '1'

  to_translate_to_resource do | raw_resource|
    raw_resource['mincapacity']
  end

end
