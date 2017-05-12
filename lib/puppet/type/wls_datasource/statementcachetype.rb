newproperty(:statementcachetype) do
  include EasyType

  desc 'Statement Cache Type'
  newvalues('FIXED', 'LRU')
  defaultto 'LRU'

  to_translate_to_resource do |raw_resource|
    raw_resource['statementcachetype']
  end

end
