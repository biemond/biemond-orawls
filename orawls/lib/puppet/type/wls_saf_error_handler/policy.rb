newproperty(:policy) do
  include EasyType

  desc 'policy of the SAF imported destination'

  newvalues(:'Discard', :'Log', :'Redirect', :'Always-forward')

  defaultto 'Discard'

  to_translate_to_resource do | raw_resource|
    raw_resource['policy']
  end

end
