newproperty(:channel_identity_customized) do
  include EasyType

  desc 'Override the server SSL Identity for this channel.'
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['channel_identity_customized']
  end

end
