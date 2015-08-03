newproperty(:setconfigurationaudittype) do
  include EasyType

  desc 'The configuration audit type'
  defaultto 'None'

  to_translate_to_resource do | raw_resource|
    raw_resource['setconfigurationaudittype']
  end

end
