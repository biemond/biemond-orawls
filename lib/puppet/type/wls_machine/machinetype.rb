newproperty(:machinetype) do
  include EasyType

  desc 'The machine type'
  defaultto 'UnixMachine'

  newvalues(:Machine, :UnixMachine)

  to_translate_to_resource do | raw_resource|
    raw_resource['machinetype']
  end

end
