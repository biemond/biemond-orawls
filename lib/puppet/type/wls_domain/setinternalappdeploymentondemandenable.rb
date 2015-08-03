newproperty(:setinternalappdeploymentondemandenable) do
  include EasyType
  
  desc 'Enable or disabled internal app deployment'
  
  to_translate_to_resource do | raw_resource|
    raw_resource['setinternalappdeploymentondemandenable']
  end

end
