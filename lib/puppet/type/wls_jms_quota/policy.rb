newproperty(:policy) do
  include EasyType

  desc "policy name of the Quota"

  newvalues('FIFO','PREEMPTIVE')
  
  to_translate_to_resource do | raw_resource|
    raw_resource['policy']
  end

end
