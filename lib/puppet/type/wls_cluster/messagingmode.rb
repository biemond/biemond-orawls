newproperty(:messagingmode) do
  include EasyType
  include EasyType::Validators::Name

  desc "The messagingmode of this cluster"

  defaultto 'unicast'


  to_translate_to_resource do | raw_resource|
    raw_resource['messagingmode']
  end

end
