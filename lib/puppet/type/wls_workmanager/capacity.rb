newproperty(:capacity) do
  include EasyType

  desc 'The capacity constraint name'

  to_translate_to_resource do | raw_resource|
    raw_resource['capacity']
  end

end
