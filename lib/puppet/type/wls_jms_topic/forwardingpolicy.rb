newproperty(:forwardingpolicy) do
  include EasyType

  desc 'forwardingpolicy of the topic, can only be set if the topic is distributed'

  to_translate_to_resource do | raw_resource|
    raw_resource['forwardingpolicy']
  end

end
