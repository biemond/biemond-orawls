newproperty(:datasourcetype) do
  include EasyType

  desc 'Datasource Type'
  newvalues('GENERIC', 'MDS', 'AGL', 'UCP', 'PROXY')
  defaultto 'AGL'

  to_translate_to_resource do |raw_resource|
    raw_resource['datasourcetype']
  end

end
