newproperty(:sslenabled) do
  include EasyType

  desc 'The ssl enabled on the server'
  newvalues('1', '0', '-1')

  defaultto '-1'

  to_translate_to_resource do | raw_resource|
    raw_resource['sslenabled']
  end

end
