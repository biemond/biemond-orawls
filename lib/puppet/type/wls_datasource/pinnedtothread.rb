newproperty(:pinnedtothread) do
  include EasyType

  desc 'Flag to keep a pooled database connection even after the application closes the logical connection'
  newvalues(true, false)

  defaultto 'false'

  to_translate_to_resource do | raw_resource|
    raw_resource['pinnedtothread']
  end

end


