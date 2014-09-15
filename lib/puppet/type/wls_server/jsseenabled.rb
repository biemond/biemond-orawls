newproperty(:jsseenabled) do
  include EasyType

  desc 'The JSSE eenabled enabled on the server'
  newvalues('1', '0')

  defaultto '0'

  to_translate_to_resource do | raw_resource|
    raw_resource['jsseenabled']
  end

end
