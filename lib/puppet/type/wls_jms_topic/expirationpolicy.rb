newproperty(:expirationpolicy) do
  include EasyType

  desc 'expirationpolicy of the topic'

  newvalues(:'Discard', :'Log', :'Redirect')

  defaultto 'Discard'

  to_translate_to_resource do | raw_resource|
    raw_resource['expirationpolicy']
  end

end
