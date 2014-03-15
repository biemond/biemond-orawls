newproperty(:expirationloggingpolicy) do
  include EasyType

  desc "expirationloggingpolicy of the queue"

  to_translate_to_resource do | raw_resource|
    raw_resource['expirationloggingpolicy']
  end

end
