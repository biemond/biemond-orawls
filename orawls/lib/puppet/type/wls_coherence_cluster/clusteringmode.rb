newproperty(:clusteringmode) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The clustering mode of this coherence cluster'

  defaultto 'unicast'

  to_translate_to_resource do | raw_resource|
    raw_resource['clusteringmode']
  end

end
