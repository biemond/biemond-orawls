newproperty(:clusteraddress) do
  include EasyType
  include EasyType::Validators::Name

  desc 'The address that forms a portion of the URL a client uses to connect to this cluster, and that is used for generating EJB handles and entity EJB failover addresses.'

  to_translate_to_resource do | raw_resource|
    raw_resource['clusteraddress']
  end

end
