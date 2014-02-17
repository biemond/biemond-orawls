newproperty(:servertype) do
  include EasyType


  desc "The service type"
  defaultto 'Both'


  to_translate_to_resource do | raw_resource|
    raw_resource['servertype']
  end


end