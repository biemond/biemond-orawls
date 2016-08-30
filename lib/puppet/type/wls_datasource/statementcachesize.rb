newproperty(:statementcachesize) do
  include EasyType

  desc 'The statement cache size of the datasource'

  to_translate_to_resource do | raw_resource|
    raw_resource['statementcachesize']
  end

end
