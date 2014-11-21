newproperty(:custom_identity) do
  include EasyType

  desc 'The custom_identity true or false'
  newvalues('1', '0', '-1')

  defaultto '-1'

  to_translate_to_resource do | raw_resource|
    raw_resource['custom_identity']
  end

end
