newproperty(:initsql) do
  include EasyType

  desc 'The datasource Init SQL statement'

  to_translate_to_resource do | raw_resource|
    raw_resource['initsql']
  end

end
