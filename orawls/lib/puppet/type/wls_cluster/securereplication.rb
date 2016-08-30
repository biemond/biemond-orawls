newproperty(:securereplication) do
  include EasyType
  include EasyType::Validators::Name

  desc 'Enable Secure Replication for the cluster'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['securereplication']
  end

end
