newproperty(:balancingpolicy) do
  include EasyType

  desc 'balancingpolicy of the distributed queue'

  newvalues(:'Round-Robin', :'Random')

  to_translate_to_resource do | raw_resource|
    raw_resource['balancingpolicy']
  end

end
