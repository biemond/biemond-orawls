newproperty(:nonpersistentqos) do
  include EasyType

  desc 'The QoS non persistent of the SAF imported destination object'

  newvalues(:"Exactly-Once", :"At-Least-Once", :"At-Most-Once")

  to_translate_to_resource do | raw_resource|
    raw_resource['nonpersistentqos']
  end

end
