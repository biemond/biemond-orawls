newproperty(:expirationloggingpolicy) do
  include EasyType

  desc "expirationloggingpolicy of the topic"

  to_translate_to_resource do | raw_resource|
    raw_resource['expirationloggingpolicy']
  end

end
