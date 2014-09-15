newproperty(:nmtype) do
  include EasyType

  desc 'The nmtype of the machine'
  defaultto 'SSL'

  newvalues(:SSL, :Plain, :SSH, :RSH)

  to_translate_to_resource do | raw_resource|
    raw_resource['nmtype']
  end

end
