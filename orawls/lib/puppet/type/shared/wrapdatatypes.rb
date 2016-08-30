newproperty(:wrapdatatypes) do
  include EasyType

  desc 'Should weblogic wrap data types.'
  newvalues('1', '0')
  defaultto '1'

  to_translate_to_resource do |raw_resource|
    raw_resource['wrapdatatypes']
  end

end
