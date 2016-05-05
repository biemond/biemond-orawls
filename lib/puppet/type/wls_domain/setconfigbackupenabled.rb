newproperty(:setconfigbackupenabled) do
  include EasyType

  desc 'Enable or disable configuration backup for the domain'
  
  to_translate_to_resource do | raw_resource|
    raw_resource['setconfigbackupenabled']
  end

end
